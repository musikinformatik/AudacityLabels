
// für dieses Programm brauchen wir eine Klasse, die im user support directory in den Extrensions abgelegt werden muss.

// bitte zuerst datei kopieren, dann die Pfade durch eigene ersetzen




(
var soundFilePath = "../example-data/afguide-first.wav".resolveRelative;
var labelFilePath = "../example-data/afguide-first.txt".resolveRelative;
s.waitForBoot { ~labels = LabeledSoundFile.read(soundFilePath, labelFilePath) }
);


(
var verben = (

	// parallel
	n: { |liste|
		var max;
		liste.value.do({ |x|
			x.play;
			x[\wort].postln;
		});
		max = liste.value.maxItem({ |x| x[\dur] });
		if(max.notNil) { max[\dur].wait };
		liste.value.clear;
	},

	// seriell
	'.': { |liste|
		liste.value.do({ |x|
			x.play;
			x[\wort].postln;
			x[\dur].wait;
		});
		liste.value.clear;
	}

);

// wir nennen die Funktion "versprechen"
~versprechen = { |satz|
	fork({
		var keller = Ref(List[]);
		var woerter = satz.split($ );
		woerter.do { |wort|
			var verb, event;
			wort = wort.asSymbol;
			verb = verben[wort];

			if(verb.isNil) {
				event = ~labels.at(wort) ? (freq: \rest, dur: 0.5pi.rand);
				keller.value.add(event);
			} {
				"-----".post; wort.postln;
				verb.value(keller);
			};

		};
		if(keller.value.size > 0) { verben['.'].value(keller) };
		"... und fertig.".postln;
	})
};
~verben = verben;
)


// von auszen neue "verben" einführen geht so:
~verben['?'] = { |liste| liste.value.do({ |x| x.put(\rate, rrand(2.0, 2.2)).put(\out, 1); }) };
// mit weniger mickey mousing:
~verben['?'] = { |liste| liste.value.do({ |x| x.put(\rate, rrand(1.0, 1.2)).put(\out, 1); }) };
// oder nur das letzte
~verben['?'] = { |liste| liste.value.last.put(\rate, rrand(1.0, 1.2)).put(\out, 1); };

// zufällige reihenfolge und manche rückwärts
(
~verben['%'] = { |liste|
	liste.value = liste.value.scramble;
	liste.value.do { |x| if(0.5.coin) { x[\rate] = (x[\rate] ? 1.0).neg }}
};
);


// ~versprechen.value("ergebnis alleine n liebe zwergenaufstand kriegsfall");

~versprechen.value("the missile knows greater at all times .");
~versprechen.value("it obtain a deviation . where where where p it isn't");

~labels[\obtains].copy.play;
~labels.dict.keys; // alle wörter

~versprechen.value("it obtain a deviation ?"); // geht das?



// nur mal so als Beispiel: ein effekt
(
SynthDef(\raum, { |out, gate = 1|
	var input = In.ar(out, 2);
	var env = EnvGen.kr(Env.asr, gate);
	var sig = GVerb.ar(input.sum * env, Rand(4, 11), revtime: Rand(0.4, 0.5), damping:Rand(0.1, 0.8));
	DetectSilence.ar(sig, doneAction: 2);
	ReplaceOut.ar(out, sig + (0.8 * input))
}).add;

~verben[\uhu] = { |liste|
	var on = (type: \on, instrument: \raum, addAction: \addToTail);
	var off = on.copy.put(\type, \off);
	liste.value.addFirst(on).add(off);
};
)

~versprechen.value("the missile knows greater at uhu all times .");


~versprechen.value("the missile uhu . knows greater at uhu . all times uhu .");


~labels.dict.keys


(
preProcessor = { |str|
	if(str.beginsWith("--")) { "~versprechen.value(\"%\")".format(str.drop(2)) } { str }
};
)


--greater
--greater at all uhu









