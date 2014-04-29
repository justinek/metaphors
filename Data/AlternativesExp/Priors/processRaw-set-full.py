import sys, re, string

fields = ["workerid", "Answer.gender", "Answer.age", "Answer.income", "Answer.categoryIDs", "Answer.orders", "Answer.animals", "Answer.featureNums","Answer.alternatives", "Answer.set1s", "Answer.set2s", "Answer.set3s", "Answer.set4s", "Answer.set5s", "Answer.set6s", "Answer.set7s", "Answer.set8s", "Answer.set1probs_animals", "Answer.set2probs_animals", "Answer.set3probs_animals", "Answer.set4probs_animals", "Answer.set5probs_animals", "Answer.set6probs_animals", "Answer.set7probs_animals", "Answer.set8probs_animals"]

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
