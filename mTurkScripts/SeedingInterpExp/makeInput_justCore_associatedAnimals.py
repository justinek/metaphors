import sys, re, string

animalsF = open("../../Data/SeedingExp/Features/allFeatures_givenAnimals.csv", "r")

#featuresF = open("../../Data/SeedingExp/alternatives_per_feature.csv", "r")

featuresF = open("../../Data/SeedingExp/features_and_associated_animals_sorted.csv", "r")

featuresDict = dict()
#superlativesDict = dict()

firstline = 0
for l in featuresF:
    if firstline == 0:
        firstline = 1
    else:
        l = l.strip()
        toks = l.split(",")
        feature = toks[1]
        alternatives = toks[2]
        superlative = toks[4]
        featuresDict[feature] = [alternatives, superlative]

maxAnimalID = 12
firstline = 0
for l in animalsF:
    if firstline == 0:
        firstline = 1
    else:
        l = l.strip()
        toks = l.split(",")
        animalID = toks[0]
        if int(animalID) <= maxAnimalID:
            animal = toks[1]
            feature = toks[2]
            superlative = featuresDict[feature][1]
            alternatives = featuresDict[feature][0]

            print '{"animalID": ' + animalID + ', "animal": "' + animal + '", "feature": "' + feature + '", "alternatives": ["' + alternatives.replace(";", '","') + '"], "numAlts":' + str(len(alternatives.split(";"))) + ', "superlative": "' + superlative + '"}, '
