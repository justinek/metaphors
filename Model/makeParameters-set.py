# read in feature priors and output feature parameters
# concatenate with rest of the church code
import sys, re, string

f = open("../Data/FeaturePriorExp/featurePriors-set-transformed.csv", "r")
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
        prob = toks[5]
        featureSetNum = int(toks[2])
        entityType = toks[1]
        if entityType == "animal":
            if categoryID in animalDict:
                animalFs = animalDict[categoryID]
                animalFs[featureSetNum] = prob
                animalDict[categoryID] = animalFs
            else:
                animalFs = dict()
                animalFs[featureSetNum] = prob
                animalDict[categoryID] = animalFs
        if entityType == "person":
            if categoryID in peopleDict:
                peopleFs = peopleDict[categoryID]
                peopleFs[featureSetNum] = prob
                peopleDict[categoryID] = peopleFs
            else:
                peopleFs = dict()
                peopleFs[featureSetNum] = prob
                peopleDict[categoryID] = peopleFs

for i in range(1,33):
    churchF = open(sys.argv[1], "r")
    writeFile = open("AnimalModels/model-" + qud + "_" + str(i) + "-set-a2-t3.church", "w")
    writeFile.write("(define featureSet-prior (list (list '" + " '".join(animalDict[i].values()) + ") (list '" + " '".join(peopleDict[i].values()) + ")))\n")
    for l in churchF:
        writeFile.write(l)
