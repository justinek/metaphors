import sys, re, string

f = open(sys.argv[1], "r")

utterances = ["giraffe", "tall", "hamster", "short"]
polarities = ["high", "high", "low", "low"]
literals = ["fig", "lit", "fig", "lit"]

print "utterance,polarity,literal,bin,prob"
for l in f:
    l = l.strip()
    interps = l.split(")) ((")
    for n in range(len(interps)):
        pairs = interps[n].split(") (")
        utterance = utterances[n]
        polarity = polarities[n]
        literal = literals[n]
        bins = pairs[0].replace("(", "").replace(")", "").split()
        values = pairs[1].replace(")", "").replace("(", "").split()
        for i in range(len(bins)):
            print utterance + "," + polarity + "," + literal + "," + bins[i] + "," + values[i]

