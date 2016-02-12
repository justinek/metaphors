import sys, re, string

animalsAndFeaturesF = open("animals_alternatives_core_expanded_features_coreAnimals.csv", "r")

animalIDF = open("Animals/allAnimals.csv", "r")

firstline = 0
idDict = dict()
for l in animalIDF:
    if firstline == 0:
        firstline = 1
    else:
        l = l.strip()
        toks = l.split(",")
        idDict[int(toks[0])] = toks[1]


firstline = 0

featureDict = dict()
for l in animalsAndFeaturesF:
    if firstline == 0:
        firstline = 1
    else:
        l = l.strip()
        toks = l.split(",")
        animals = toks[1].split(";")
        coreFeatures = toks[2].split(";")
        expandedFeatures = toks[3].split(";")
        allFeatures = coreFeatures + expandedFeatures
        for animal in animals:
            if animal not in featureDict:
                featureDict[animal] = allFeatures
            else:
                featureDict[animal] = list(set(featureDict[animal] + allFeatures))

for i in range(len(idDict.keys())):
    animal = idDict[i+1]
    if animal in featureDict:
        print str(i + 1) + "," + animal + "," + ";".join(featureDict[animal])
print str(30) + ",man," + ";".join(featureDict["man"])
