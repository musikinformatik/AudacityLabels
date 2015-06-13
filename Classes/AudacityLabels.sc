

AudacityLabels {

	var <dict, <>verbose = true, <>rejectDuplicates = false;

	*new {
		^super.new.clear
	}

	*read { |labelPath|
		^this.new.read(labelPath)
	}

	clear {
		dict = BagEnvironment.new;
	}

	at { |wort|
		^dict.get(wort)
	}

	put { |wort, event|
		if(rejectDuplicates and: { dict[wort].notNil }) {
			"Duplicate Labels not allowed, overwriting previous label '%'".format(wort).warn;
			dict.removeAt(wort);
		};
		dict[wort] = event;
	}

	read { |labelPath|
		var string = File.use(labelPath, "r", { |file| file.readAllString });
		this.parseAndAddLabels(string, labelPath);
	}

	parseAndAddLabels { |string, labelPath|
		var zeilen = string.split(Char.nl);
		if(verbose) { "Reading labels from: %\n\n".postf(labelPath) };
		zeilen.do({ |zeile, i|
			var daten, t0, t1, wort, event;
			daten = zeile.split(Char.tab);
			if(daten.size >= 3) {
				t0 = daten[0].replace(",", ".").asFloat; // account for format bug in audacity: convert to dot.
				t1 = daten[1].replace(",", ".").asFloat;
				wort = daten[2];
				if(wort.isEmpty or: { wort.every { |char| char.isSpace }}) {
					wort = i
				} {
					wort = wort.asSymbol
				};
				event = (
					wort: wort,
					t0: t0,
					t1: t1,
					rate: 1.0,
					gap: 0.0,
					finish: {
						var dt = ~t1 - ~t0;
						~start !? { ~t0 = ~t0 + (dt * ~start) };
						~end !? { ~t1 = ~t0 + (dt * ~end) };
						~dur = abs((~t1 - ~t0) / ~rate) + ~gap;
					}
				);
				this.put(wort, event);
				if(verbose) { wort.post; " ".post; }
			};
		});
		if(verbose) { "\n".post };
	}

}

LabeledSoundFile {

	var <buffers, <dict, <>verbose = true, <>rejectDuplicates = false;

	*new {
		^super.new.clear
	}

	clear {
		buffers.do { |x| x.free };
		buffers = [];
		dict = BagEnvironment.new;
	}

	get { |wort, choiceFunc|
		^dict.get(wort.asSymbol, choiceFunc ? {|x| x.choose }).copy
	}

	at { |wort|
		^dict.get(wort.asSymbol, {|x| x.choose }).copy
	}

	*read { |soundFilePath, labelPath, server|
		^this.new.read(soundFilePath, labelPath, server)
	}

	read { |soundFilePath, labelPath, server, finishFunc|
		var labels;
		server = server ? Server.default;
		if(server.serverRunning.not) { "Server not running!".warn; ^this };
		fork {
			var buffer = this.getBuffer(server, soundFilePath);
			// todo: check if buffer exists and add it to the list.
			server.sync;
			labels = AudacityLabels.new.verbose_(verbose).rejectDuplicates_(rejectDuplicates);
			labels.read(labelPath);
			labels.dict.keysValuesDo { |key, event|
				event[\server] = server;
				event[\buffer] = buffer;
				event[\instrument] = if(buffer.numChannels == 2) { \labelPlayer_2 } { \labelPlayer_1 };
				dict.put(key, event);
			};
			finishFunc.value(this);
		}
	}

	getBuffer { |server, path|
		var buffer = buffers.detect { |buf| buf.path == path and: { buf.server == server } };
		if(buffer.isNil) {
			buffer = Buffer.read(server, path);
			buffers = buffers.add(buffer)
		};
		^buffer
	}

	defaultEvent {
		^(type: \rest, dur: 0)
	}

	maxWordSize {
		var max = 0;
		dict.keysDo { |name| max = max(max, name.asString.size) };
		^max
	}

	*initClass {

		SynthDef(\labelPlayer_1, { |out = 0, rate = 1, t0, t1, buffer, pan, amp = 0.1|
			var sustain;
			var ton, env, channels;
			sustain = abs((t1 - t0) / rate); // Gesamtdauer
			env = EnvGen.kr(
				Env.linen(0.001, sustain, 0.01, (amp * 10)),
				doneAction:2 // die Hüllkurve beendet den Synth
			);

			ton = env * PlayBuf.ar(
				1, // mono
				buffer, // der buffer,
				rate * BufRateScale.kr(buffer), // Abspielrate mit Ausgleich
				startPos:BufSampleRate.kr(buffer) * t0, // Startposition
				loop: 1 // falls wir versehentlich über das Ende hinausgehen
			);
			OffsetOut.ar(out, Pan2.ar(ton, pan))
		}).add;

		SynthDef(\labelPlayer_2, { |out = 0, rate = 1, t0, t1, buffer, pan, amp = 0.1|
			var sustain;
			var ton, env, channels;

			sustain = abs((t1 - t0) / rate); // Gesamtdauer
			env = EnvGen.kr(
				Env.linen(0.001, sustain, 0.01, (amp * 10)),
				doneAction:2 // die Hüllkurve beendet den Synth
			);

			ton = env * PlayBuf.ar(
				2, // stereo
				buffer, // der buffer,
				rate * BufRateScale.kr(buffer), // Abspielrate mit Ausgleich
				startPos:BufSampleRate.kr(buffer) * t0, // Startposition
				loop: 1 // falls wir versehentlich über das Ende hinausgehen
			);
			OffsetOut.ar(out, Balance2.ar(ton[0], ton[1], pan))
		}).add;


	}
}












