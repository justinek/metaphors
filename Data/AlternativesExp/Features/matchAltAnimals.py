import sys, re, string

# file with top10 features
altF = open(sys.argv[1], "r")

alternatives = dict()

altFirstline = 0
for l in altF:
    l = l.strip()
    if altFirstline == 0:
        altFirstline = 1
    else:
        toks = l.split(",")
        feature = toks[2]
        altAnimal = toks[0]
        if feature in alternatives:
            alternatives[feature].append(altAnimal)
        else:
            alternatives[feature] = [altAnimal]

# file with categoryIDs, animals, and features
f = open(sys.argv[2], "r")

firstline = 0
for l in f:
    l = l.strip()
    if firstline == 0:
        firstline = 1
        print l + "," + "alternatives"
    else:
        toks = l.split(",")
        thisFeature = toks[2]
        thisAnimal = toks[1]
        
        thisAlternatives = alternatives[thisFeature]
        topN = []
        if len(thisAlternatives) <= 2:
            topN = thisAlternatives
        if thisAnimal in thisAlternatives[0:2]:
            topN = thisAlternatives[0:3]
        else:
            topN = thisAlternatives[0:2]
        if thisAnimal in topN:
            topN.remove(thisAnimal)
        print l + "," + ";".join(topN)
