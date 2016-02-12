import sys, re, string

f = open("../../Data/SeedingExp/features_and_associated_animals_sorted.csv", "r")

firstline = 0
for l in f:
    if firstline == 0:
        firstline = 1
    else:
        l = l.strip()
        toks = l.split(",")
        featureID = toks[0]
        feature = toks[1]
        animals = toks[2]
        numAnimals = toks[3]
        superlative = toks[4]

        print '{"featureID": ' + featureID + ', "feature": "' + feature + '", "animals": ["' + animals.replace(";", '","') + '"], "numAnimals":' + numAnimals + ', "superlative": "' + superlative + '"}, '
