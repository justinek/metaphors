import sys, re, string
import itertools

f = open(sys.argv[1], "r")

featureDict = dict()
antonymDict = dict()
alternativesDict = dict()

for l in f:
    l = l.strip().lower()
    toks = l.split(",")
    catID = toks[0]
    animal = toks[1]
    feature = toks[2]
    ant = toks[3]
    count = 4 - int(toks[4])
    alternatives = toks[5]
    alternativesDict[catID + "," + feature] = alternatives
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

categoryID = 1
vowels = ["a", "e", "i", "o", "u"]
for animal in sorted(featureDict.iterkeys()):
    d = featureDict[animal]
    #if animal[0] in vowels:
    #    det = "an"
    #else:
    #    det = "a"
    features = []
    for feature in sorted(d, key=d.get, reverse=True):
        features.append(feature)
    ad = antonymDict[animal]
    ants = []
    for ant in sorted(ad, key=ad.get, reverse=True):
        ants.append(ant)
    setGenerator = itertools.product([True, False], repeat=3)
    featureSets = []
    for s in setGenerator:
        featureSet = []
        for i in range(len(s)):
            if s[i] == True:
                featureSet.append(features[i])
            else:
                featureSet.append(ants[i])
        featureSets.append(featureSet)
    information = '{"categoryID":' + str(categoryID) + ',"animal":"' + animal + '",'
    #print str(categoryID) + "," + animal + ",",
    #print '{"categoryID":' + str(categoryID) + ',"determiner":"' + det + '","animal":"' + animal + '",',
    setLabels = ""
    for setnum in range(len(featureSets)):
        #print ";".join(featureSets[setnum]) + ",",
        #print '"set' + str(setnum + 1) + '":"' + ", ".join(featureSets[setnum]) +'",',
        setLabels = setLabels + '"set' + str(setnum + 1) + '":"' + ", ".join(featureSets[setnum]) + '",'
    information = information + setLabels
    featureNum = 1
    for feature in features:
        theseAlts = alternativesDict[str(categoryID) + "," + feature].split(";")
        for thisAlt in theseAlts:
            if thisAlt[0] in vowels:
                det = "an"
            else:
                det = "a"
            thisInfo = information + '"alternative":"' + thisAlt + '","det":"' + det + '","featureNum":' + str(featureNum) + '},'
            print thisInfo
        featureNum = featureNum + 1
    #print "},\n",
   
    categoryID = categoryID + 1

