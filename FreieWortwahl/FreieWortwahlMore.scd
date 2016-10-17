
// von auszen neue "verben" einführen geht so:
~verben['?'] = { |liste, von, bis| liste[von..bis].do({ |x| x.put(\rate, rrand(2.0, 2.2)) }) };
// mit weniger mickey mousing:
~verben['?'] = { |liste, von, bis| liste[von..bis].do({ |x| x.put(\rate, rrand(1.0, 1.2)) }) };
// oder nur das letzte
~verben['?'] = { |liste, von, bis| liste.last.put(\rate, rrand(1.0, 1.2)) };

~verspreche.value("the missile knows greater at all ? times *");
~stop.value;


// zufällige reihenfolge und manche rückwärts
(
~verben['%'] = { |liste|
	liste.value = liste.value.scramble;
	liste.value.do { |x| if(0.5.coin) { x[\rate] = (x[\rate] ? 1.0).neg }}
};
);


// ~verspreche.value("ergebnis alleine n liebe zwergenaufstand kriegsfall");

~verspreche.value("the missile knows greater at all times .");
~verspreche.value("it obtain a deviation ? where where where p it isn't . ");
~stop.value;
~labels[\obtains].copy.play;
~labels.dict.keys; // alle wörter

~verspreche.value("it obtain a deviation ?"); // geht das?



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

~verspreche.value("the missile knows greater at uhu all times .");


~verspreche.value("the missile uhu . knows greater at uhu . all times uhu .");
