import sys, re, string

f = open("../../Data/SeedingExp/Features/allFeatures_givenAnimals.csv", "r")

featuresDict = dict()

firstline = 0
for l in f:
    if firstline == 0:
        firstline = 1
    else:
        l = l.strip()
        toks = l.split(",")
        animalID = int(toks[0])
        animal = toks[1]
        feature = toks[2]
        if animalID in featuresDict:
            featuresDict[animalID][animal].append(feature)
        else:
            featuresDict[animalID] = dict()
            featuresDict[animalID][animal] = [feature]

for k, v in featuresDict.iteritems():
    animalID = k
    animal = "".join(featuresDict[k].keys());
    features = featuresDict[animalID][animal]
    print '{"animalID": ' + str(animalID) + ', "animal": "' + animal + '", "features": ["' + '","'.join(features) +'"]},'
