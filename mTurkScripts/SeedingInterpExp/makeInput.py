import sys, re, string

f = open("../../Data/SeedingExp/animals_alternatives_features_sorted.csv", "r")

firstline = 0
for l in f:
    if firstline == 0:
        firstline = 1
    else:
        l = l.strip()
        toks = l.split(",")
        animalID = toks[0]
        animal = toks[1]
        features = toks[3]
        numFeatures = toks[5]
        print '{"animalID": ' + animalID + ', "animal": "' + animal + '", "features": ["' + features.replace(";", '","') +'"],' + ' "numFeatures": ' + str(numFeatures) + '}, '
