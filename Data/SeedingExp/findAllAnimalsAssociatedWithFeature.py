import sys, re, string

# Read in "alternatives_per_feature_sorted.csv"
# For each feature, find all the animals associated with it, whether through
# direct association, or by virtue of being in the same alternative set as
# an animal that has that feature

animalsDict = dict()

f = open("alternatives_per_feature_sorted.csv")

firstline = 0
for l in f:
    if firstline == 0:
        firstline = 1
    else:
        l = l.strip()
        toks = l.split(",")
        feature = toks[3]
        alternatives = toks[4].split(";")
        if feature not in animalsDict:
            animalsDict[feature] = alternatives
        else:
            animalsDict[feature] = list(set(animalsDict[feature] + alternatives))

print "feature,animals,numAnimals"
for k, v in animalsDict.iteritems():
    print k + "," + ";".join(v) + "," + str(len(v))




