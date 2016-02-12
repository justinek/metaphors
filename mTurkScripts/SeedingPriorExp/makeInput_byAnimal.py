import sys, re, string

f = open("../../Data/SeedingExp/animals_expandedFeatures.csv", "r")

for l in f:
    l = l.strip()
    toks = l.split(",")
    animalID = toks[0]
    animal = toks[1]
    features = toks[2]
    numFeatures = len(features.split(";"))

    print '{"animalID": ' + animalID + ', "animal": "' + animal + '", "features": ["' + features.replace(";", '","') + '"], "numFeatures":' + str(numFeatures) + '}, '
