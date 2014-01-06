import sys, re, string

subjectFields = ["workerid", "Answer.gender", "Answer.age", "Answer.income"]
itemFields = ["Answer.categoryIDs","Answer.orders","Answer.speakers","Answer.animals","Answer.f1s","Answer.f2s","Answer.f3s","Answer.conditions","Answer.f1probs" ,"Answer.f2probs", "Answer.f3probs"]

subjectIndices = []
itemIndices = []

f = open(sys.argv[1], "r")
firstline = 0
for l in f:
    l = l.strip()
    if firstline == 0:
        firstline = 1
        toks = l.split("\t")
        subjectIndices = [toks.index(s) for s in subjectFields]
        itemIndices = [toks.index(i) for i in itemFields]
        print "workerid,gender,age,income,categoryID,order,speaker,animal,f1,f2,f3,condition,f1prob,f2prob,f3prob"
    else:
        toks = l.split("\t")
        numItems = len(toks[itemIndices[0]].split(","))
        subjects = [toks[si] for si in subjectIndices]
        items = [toks[ii] for ii in itemIndices]
        for j in range(numItems):
            itemstoprint = []
            for item in items:
                itemstoprint.append(item.split(",")[j])
            print ",".join(subjects) + "," + ",".join(itemstoprint)
