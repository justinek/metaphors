# Only consider the top 2 features

import sys, re, string
import itertools

f = open(sys.argv[1], "r")

featureDict = dict()
antonymDict = dict()
categoryID = 1
for l in f:
    l = l.strip().lower()
    toks = l.split(",")
    animal = toks[2]
    feature = toks[0]
    #ant = toks[1]
    ant = "not " + feature
    count = int(toks[3])
    if count > 1:
        if animal in featureDict:
            features = featureDict[animal]
            features[feature] = count
            featureDict[animal] = features
        else:
            features = dict()
            features[feature] = count
            featureDict[animal] = features
        if animal in antonymDict:
            ants = antonymDict[animal]
            ants[ant] = count
            antonymDict[animal] = ants
        else:
            ants = dict()
            ants[ant] = count
            antonymDict[animal] = ants

vowels = ["a", "e", "i", "o", "u"]
for animal in sorted(featureDict.iterkeys()):
    d = featureDict[animal]
    if animal[0] in vowels:
        det = "an"
    else:
        det = "a"
    features = []
    for feature in sorted(d, key=d.get, reverse=True):
        features.append(feature)
    ad = antonymDict[animal]
    ants = []
    for ant in sorted(ad, key=ad.get, reverse=True):
        ants.append(ant)
    setGenerator = itertools.product([True, False], repeat=2)
    featureSets = []
    for s in setGenerator:
        featureSet = []
        for i in range(len(s)):
            if s[i] == True:
                featureSet.append(features[i])
            else:
                featureSet.append(ants[i])
        featureSets.append(featureSet)
    print '{"categoryID":' + str(categoryID) + ',"determiner":"' + det + '","animal":"' + animal + '",',
    for setnum in range(len(featureSets)):
        print '"set' + str(setnum + 1) + '":"' + "; ".join(featureSets[setnum]) +'",',
    print "},\n",
    categoryID = categoryID + 1
