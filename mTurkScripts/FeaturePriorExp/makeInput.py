import sys, re, string

f = open(sys.argv[1], "r")

featureDict = dict()
categoryID = 1
for l in f:
    l = l.strip().lower()
    toks = l.split(",")
    animal = toks[2]
    feature = toks[0]
    count = int(toks[1])
    if animal in featureDict:
        features = featureDict[animal]
        features[feature] = count
        featureDict[animal] = features
    else:
        features = dict()
        features[feature] = count
        featureDict[animal] = features

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
    print '{"categoryID":' + str(categoryID) + ',"determiner":"' + det + '","animal":"' + animal + '","f1":"' + features[0] + '","f2":"' + features[1] + '","f3":"' + features[2] + '"},' 
    categoryID = categoryID + 1
