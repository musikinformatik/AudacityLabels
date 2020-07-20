

(
var soundFilePath = "example-data/afguide-first.wav".resolveRelative;
var labelFilePath = "example-data/afguide-first.txt".resolveRelative;
s.waitForBoot { ~labels = LabeledSoundFile.read(soundFilePath, labelFilePath) }
);


~labels.dict.keys.do { |x| x.postln }; "" // post all label names, they are symbols


x = ~labels.at('difference'); // returns an event (a copy of the original)
x.play; // play the event

x.use { ~rate = 1.2 }; /// modify parameters
x.play;

Pseq(['because', 'difference', 'from', 'deviation']).collect { |x| ~labels.at(x) }.play;

