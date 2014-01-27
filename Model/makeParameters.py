# read in feature priors and output feature parameters
# concatenate with rest of the church code
import sys, re, string

f = open("../Data/FeaturePriorExp/featurePriors-names.csv", "r")
qud = sys.argv[2]

animalDict = dict()
peopleDict = dict()

firstline = 0
for l in f:
    l = l.strip()
    if firstline == 0:
        firstline = 1
    else:
        toks = l.split(",")
        categoryID = int(toks[0])
        prob = toks[6]
        featureNum = int(toks[11])
        entityType = toks[12]
        if entityType == "animal":
            if categoryID in animalDict:
                animalFs = animalDict[categoryID]
                animalFs[featureNum] = prob
                animalDict[categoryID] = animalFs
            else:
                animalFs = dict()
                animalFs[featureNum] = prob
                animalDict[categoryID] = animalFs
        if entityType == "person":
            if categoryID in peopleDict:
                peopleFs = peopleDict[categoryID]
                peopleFs[featureNum] = prob
                peopleDict[categoryID] = peopleFs
            else:
                peopleFs = dict()
                peopleFs[featureNum] = prob
                peopleDict[categoryID] = peopleFs

for i in range(1,33):
    churchF = open(sys.argv[1], "r")
    writeFile = open("AnimalModels/model-" + qud + "_" + str(i) + ".church", "w")
    for fNum in range(1, 4):
        writeFile.write("(define feature" + str(fNum) + "-prior (list (list 'animal '" + animalDict[i][fNum] + ") (list 'person '" + peopleDict[i][fNum] + ")))\n")
    for l in churchF:
        writeFile.write(l)
