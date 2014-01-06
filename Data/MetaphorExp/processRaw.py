import sys, re, string

fields = ["workerid", "Answer.gender", "Answer.age", "Answer.income", "Answer.categoryIDs", "Answer.orders", "Answer.speakers", "Answer.animals", "Answer.f1s", "Answer.f2s", "Answer.f3s", "Answer.conditions", "Answer.f1probs", "Answer.f2probs", "Answer.f3probs"]

indices = []

f = open(sys.argv[1], "r")
firstline = 0
for l in f:
    l = l.strip().translate(None, '"[]')
    if firstline == 0:
        firstline = 1
        toks = l.split("\t")
        print "\t".join(fields)
        for field in fields:
            indices.append(toks.index(field))
    else:
        toks = l.split("\t")
        tokeep = [toks[i] for i in indices]
        print "\t".join(tokeep)
