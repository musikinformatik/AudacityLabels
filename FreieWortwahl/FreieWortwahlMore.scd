~stop.value;

// von auszen neue "verben" einführen geht so:
~verben['?'] = { |liste| liste.do({ |x| x.put(\rate, rrand(2.0, 2.2)) }) };
~sage.value("the missile knows greater at all times ?");

// mit weniger mickey mousing:
~verben['?'] = { |liste| liste.do({ |x| x.put(\rate, rrand(1.0, 1.2)) }) };
~sage.value("the missile knows greater at all times ?");


// oder nur das letzte
~verben['?'] = { |liste| liste.last.put(\rate, rrand(1.0, 1.2)); liste };
~sage.value("the missile knows greater at all times ?");




// zufällige reihenfolge und manche rückwärts
(
~verben['%'] = { |liste|
	liste = liste.scramble;
	liste.do { |x| if(0.3.coin) { x[\rate] = (x[\rate] ? 1.0).neg }};
	liste
};
);

~sage.value("the missile knows greater at all times %");
~sage.value("the missile knows greater at all times % ?");



// jedes wort im takt
(
~verben['*='] = { |liste|
	liste.do { |x|
		var dt = TempoClock.default.timeToNextBeat(1).postln;
		x.play;
		x[\wort].post; " ".post;
		dt.wait; //1.wait;
	};
	[]
}
)

~stop.();
~sage.value("the missile knows greater at all times *=");




/*
(
~verben['*=='] = { |liste|
var zeitDieWirHaben = TempoClock.default.timeToNextBeat(2);
var totalNormalDur = liste.sum { |x| x[\dur] ? 0 };
var rate = totalNormalDur / zeitDieWirHaben;
"rate: ".post; rate.postln;
liste.do({ |x| x.put(\rate, rate) });
liste
};
)
*/

~verspreche.value("the missile knows *= *  greater at all times *= *");
~stop.value;
~kanaele[\standard][\inhalt]



// ~verspreche.value("ergebnis alleine n liebe zwergenaufstand kriegsfall");

~sage.value("the missile knows  % greater at all times .");
~sage.value("it obtain a deviation ? where where where ** it isn't . ");
~stop.value;
~labels[\obtains].copy.play;
~labels.dict.keys; // alle wörter



// nur mal so als Beispiel: ein effekt (geht noch nicht ganz so wie man möchte)

(
SynthDef(\raum, { |out, gate = 1|
	var input = In.ar(out, 2);
	var env = EnvGen.kr(Env.asr, gate);
	var sig = GVerb.ar(input.sum * env, Rand(4, 11), revtime: Rand(0.4, 0.5), damping:Rand(0.1, 0.8));
	sig = Limiter.ar(sig, 0.5);
	DetectSilence.ar(sig, doneAction: 2);
	ReplaceOut.ar(out, sig + (0.8 * input))
}).add;

~verben[\uhu] = { |liste|
	var on = (type: \on, instrument: \raum, addAction: \addToTail, dur: 0);
	var off = on.copy.put(\type, \off);
	liste = liste.addFirst(on).add(off);
	liste
};
)

~sage.value("the missile knows greater at all times uhu *");

~verspreche.value("the missile uhu knows greater at uhu all times uhu *");


// alles zusammen:

~verspreche.value("the missile uhu knows greater ? at uhu all times uhu *");

