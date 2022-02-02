


(
var rejectDuplicates = true;
var soundFilePath = "example-data/afguide-first.wav".resolveRelative;
var labelFilePath = "example-data/afguide-first.txt".resolveRelative;
s.waitForBoot { ~labels = LabeledSoundFile(rejectDuplicates: rejectDuplicates).read(soundFilePath, labelFilePath) }
);


~labels.dict.keys.do { |x| x.postln }; "" // post all label names, they are symbols


x = ~labels.at('difference'); // returns an event (a copy of the original)
x.play; // play the event

x.use { ~rate = 1.2 }; /// modify parameters
x.play;

// sequencing in a task
(
Tdef(\x, {
	var keys = ~labels.dict.keys;
	5.do {
		~labels.at(keys.choose).play;
		0.4.wait;
	}
}).play
)

// sequencing in a contiguous series
(
Tdef(\x, {
	var keys = ~labels.dict.keys;
	var event;
	15.do {
		event = ~labels.at(keys.choose);
		event.play; // this calls ~finish, then the dur is in the event:
		event[\dur].wait;
	}
}).play
)


// sequencing with patterns

// a pattern of names
p = Pseq(['because', 'difference', 'from', 'deviation']);

// because ~labels understand the message "at", you can use a Pdict to get the events
// the delta times (dur) are automatically calculated

k = Pdict(~labels, p);
k.play;

// there are a number of parameters that modify the playback.

// change the gap between subsequent parts:
(
Pbindf(k,
	\gap, 0.3
).play
)

// change the playback rate
(
Pbindf(k,
	\rate, 1.25
).play
)

// multichannel expansion
// by default, the first channel guides the durations
(
Pbindf(k,
	\rate, [1, 1.25, 1.5]
).play
)

// use the third channel as a guide
// because it plays faster, the resuling voices will overlap
(
Pbindf(k,
	\rate, [1, 1.25, 1.5],
	\guidIndex, 2,
).play
)

// panning. In the case of a stereo file, this will rotate the channels
(
Pbindf(k,
	\pan, Pseq([-1, 0], inf)
).play
)




