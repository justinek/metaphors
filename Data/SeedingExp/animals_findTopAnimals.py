# For each feature, find salient animals.
# Salience is defined as the top most frequent animals per feature,
# such that the number of responses for the salient animals is 1/2 of the total responses.
# If the top animal is already more than 1/2 of the total responses, then include the second
# highest animal. None of the included animals can have only 1 response.

import sys, re, string

f = open(sys.argv[1], "r")
totalNum = 50
threshold = 50/2

firstline = 0
currentFeature = ""
currentCount = 0
currentNumAnimals = 0

for l in f:
    if firstline == 0:
        firstline = 1
    else:
        l = l.strip()
        toks = l.split(",")
        feature = toks[1]
        animal = toks[2]
        count = int(toks[3])
        if feature != currentFeature:
            currentCount = count
            currentFeature = feature
            currentNumAnimals = 1
            print l
        else:
            if currentCount <= threshold or currentNumAnimals == 1:
                currentCount = currentCount + count
                currentNumAnimals = currentNumAnimals + 1
                if count > 1:
                    print l



