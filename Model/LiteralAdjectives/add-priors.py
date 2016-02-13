# Read in feature priors for each animal from featrePriors-set-wide
# Based on selection of alternative animals, print out priors in church format

import sys, re, string

priors = open(sys.argv[1], "r")

altDict = dict()

firstline = 0
for l in priors:
    l = l.strip().replace('"', "")
    if firstline == 0:
        firstline = 1
    else:
        toks = l.split(",")
        target = toks[1]
        categoryID = toks[0]
        alternative = toks[3]
        if target == alternative:
            alternative = "target"
        if categoryID in altDict:
            altDict[categoryID][alternative] = toks[4:]
        else:
            newDict = dict()
            altDict[categoryID] = newDict
            altDict[categoryID][alternative] = toks[4:]

for i in range(len(altDict)):
    catID = str(i + 1)
    writeF = open("WithPriorsMetaphor/ID-" + catID + ".church", "w")
    animals = []
    featurePriors = []
    for a, p in altDict[catID].iteritems():
        animals.append(a)
        featurePriors.append(p)

    utterancePriors = [str(0.1) for i in animals]
    categoryPriors = []
    for i in animals:
        if i != "person":
            categoryPriors.append(str((1-0.99)/(len(animals)-1)))
        else:
            categoryPriors.append("0.99")

    writeF.write("(define categories (list 'person 'target))\n")
    writeF.write("(define utterances (list 'target 'f1-1 'f1-0 'f2-1 'f2-0 'f3-1 'f3-0))\n")
    writeF.write("(define (utterance-prior) (multinomial utterances '(0.1 0.1 0.1 0.1 0.1 0.1 0.1)))\n")
    writeF.write("(define (categories-prior) (multinomial categories '(" + " ".join(categoryPriors) + ")))\n")
    writeF.write("(define featureSet-prior (list")
    for fp in featurePriors:
        writeF.write("(list '" + " '".join(fp) + ")")
    writeF.write("))\n")
   
    # Base church program
    f = open(sys.argv[2], "r")
    for l in f:
        l = l.strip()
        writeF.write(l + "\n")

