import sys, re, string

f = open(sys.argv[1], "r")

fields = ["workerid", "Answer.gender", "Answer.nativeLanguage", "Answer.income", "Answer.age", "Answer.orders", "Answer.animalIDs", "Answer.animals", "Answer.adjectives"]
indices = []

firstline = 0
for l in f:
    l = l.strip()
    if firstline == 0:
        firstline = 1
        l = l.replace('"', "")
        toks = l.split("\t")
        for field in fields:
            indices.append(toks.index(field))
        print "\t".join(fields)
    else:
        toKeep = []
        l = l.replace('"', "").replace("[", "").replace("]", "")
        toks = l.split("\t")
        for i in indices:
            toKeep.append(toks[i].replace(" ", ""))
        print "\t".join(toKeep)
            
