# Read in feature priors for each animal from featrePriors-set-wide
# Based on selection of alternative animals, print out priors in church format

import sys, re, string

#priors = open("../../Data/AlternativesExp/Priors/featurePriors-set-wide.csv", "r")
priors = open(sys.argv[1], "r")

# Base church program
f = open(sys.argv[2], "r")

altDict = dict()

firstline = 0
for l in priors:
    l = l.strip().replace('"', "")
    if firstline == 0:
        firstline = 1
    else:
        toks = l.split(",")
        animal = toks[1]
        altDict[animal] = toks[2:]

animals = []
featurePriors = []

if sys.argv[2] == "all":
    for a, p in altDict.iteritems():
        animals.append(a)
        featurePriors.append(p)
else:
    animals.append("whale")
    animals.append("person")
    featurePriors.append(altDict["whale"])
    featurePriors.append(altDict["person"])

utterancePriors = [str(0.1) for i in animals]
categoryPriors = []
for i in animals:
    if i != "person":
        categoryPriors.append(str((1-0.99)/(len(animals)-1)))
    else:
        categoryPriors.append("0.99")

print "(define categories (list '" + " '".join(animals) + "))"
print "(define utterances (list '" + " '".join(animals) + "))"
print "(define (utterance-prior) (multinomial utterances '(" + " ".join(utterancePriors) + ")))"
print "(define (categories-prior) (multinomial categories '(" + " ".join(categoryPriors) + ")))"
print "(define featureSet-prior (list",
for fp in featurePriors:
    print "(list '" + " '".join(fp) + ")",
print "))"

for l in f:
    l = l.strip()
    print l

