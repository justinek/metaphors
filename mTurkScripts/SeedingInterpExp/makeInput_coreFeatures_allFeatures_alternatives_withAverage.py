import sys, re, string

f = open("../../Data/SeedingExp/animals_alternatives_features_sorted.csv", "r")

coreDictF = open("../../Data/SeedingExp/Features/allFeatures_givenAnimals.csv", "r")

coreDict = dict()

firstline = 0
for l in coreDictF:
    if firstline == 0:
        firstline = 1
    else:
        l = l.strip()
        toks = l.split(",")
        animalID = toks[0]
        animal = toks[1]
        feature = toks[2]
        if animalID in coreDict:
            coreDict[animalID][animal].append(feature)
        else:
            coreDict[animalID] = dict()
            coreDict[animalID][animal] = [feature]

firstline = 0
for l in f:
    if firstline == 0:
        firstline = 1
    else:
        l = l.strip()
        toks = l.split(",")
        animalID = toks[0]
        animal = toks[1]
        alternatives = toks[2]
        features = toks[3]
        coreFeatures = coreDict[animalID][animal]
        #numAlts = toks[4]
        #numFeatures = toks[5]
        print '{"animalID": ' + animalID + ', "animal": "' + animal + '", "coreFeatures": ["' + '","'.join(coreFeatures) + '"], "features": ["' + features.replace(";", '","') +'"],' + ' "alternatives": ["' + alternatives.replace(";", '","') + '", "average man"]}, '
