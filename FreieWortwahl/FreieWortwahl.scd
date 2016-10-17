
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
	'*n': { |liste, von, bis|
		var max;
		liste[von .. bis].do({ |x|
			x.play;
			x[\wort].postln;
		});
		max = liste.value.maxItem({ |x| x[\dur] });
		if(max.notNil) { max[\dur].wait };
	},

	// seriell
	'*': { |liste, von, bis|
		liste[von .. bis].do({ |x|
			x.play;
			x[\wort].postln;
			x[\dur].wait;
		});
	}

);

var kanaele = ();

var verwandle = { |satz|
	var events, woerter = satz.split($ );

	woerter.do { |wort|
		var verb, event;
		wort = wort.asSymbol;
		verb = verben[wort];

		if(verb.isNil) {
			event = ~labels.at(wort);
			if(event.isNil) {
				event = (freq: \rest, dur: 0.5pi.rand, wort: "(%)".format(wort))
			}
		} {
			event = (type: \verb, wort: wort, play: verb)
		};
		events = events.add(event);

	};
	events

};

var sage = { |satz,  kanal = \standard|
	var last = satz.split($ ).last.asSymbol;
	if(verben[last].isNil) {
		satz = satz ++ " *";
	};
	verspreche.(satz)
};

var verspreche = { |satz, kanal = \standard|
	var keller, events, hatExistiert;

	events = verwandle.(satz);
	keller = kanaele[kanal];
	hatExistiert = keller.notNil;

	if(keller.isNil) {
		keller = (
			inhalt: List[],
			condition: Condition.new
		);
		if(kanal.notNil) { kanaele[kanal] = keller };
	};

	keller[\inhalt].addAll(events);

	"in den Keller gelegt: %\n\n".postf(events.collect { |x| x[\wort] }.join(" ").quote);
	"neuer Kellerinhalt: %\n\n".postf(keller[\inhalt].collect { |x| x[\wort] }.join(" ").quote);

	if(hatExistiert) { setzeFort.value(keller) } { starte.value(keller) };

};

var setzeFort = { |keller| keller[\condition].unhang };

var starte = { |keller|
	keller[\prozess] = fork {
		var von = 0, bis = 0, event;
		loop {
			event = keller[\inhalt][bis];
			if(event.notNil and: { event[\type] == \verb }) {
				"VERB: %\n".postf(event[\wort]);
				event[\play].value(keller[\inhalt], von, bis - 1);
				von = bis = bis + 1
			} {
				bis = bis + 1
			};

			if(bis > (keller[\inhalt].lastIndex)) {
				keller[\condition].hang;
			}
		};
	}
};

var stop = { |kanal = \standard|
	var keller = kanaele[kanal];
	keller[\prozess].stop;
	keller[\inhalt].clear;
	kanaele[kanal] = nil;
};

if(~labels.isNil) {
	"Ich kann leider keine Sound File Labels finden. Bitte noch nachladen!".warn;
};

// external access
~verben = verben;
~verspreche = verspreche;
~kanaele = kanaele;
~stop = stop;
~sage = sage;
)

~verspreche.value("obtains ."); ~verspreche.value("obtains . ");

~verspreche.value("obtains deviation * ");
~verspreche.value("obtains deviation * deviation times *");


~verspreche.value("the missile knows greater at all times mmlli times times tiimes");
~sage.value("the the");

~labels.dict.keys

~stop.value;


~kanaele[\standard]


(
preProcessor = { |str|
	if(str.beginsWith("--")) { "~verspreche.value(\"%\")".format(str.drop(2)) } { str }
};
)


--greater
--greater at all uhu






