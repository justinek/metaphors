import sys, re, string, math

def meanstdv(x):
    from math import sqrt
    n, mean, std = len(x), 0, 0
    for a in x:
        mean = mean + a
    mean = mean / float(n)
    for a in x:
        std = std + (a - mean)**2
    std = sqrt(std / float(n-1))
    return mean, std

subjectFields = ["workerid", "Answer.gender", "Answer.age", "Answer.income"]
itemFields = ["Answer.categoryIDs","Answer.orders","Answer.speakers","Answer.animals","Answer.f1s","Answer.f2s","Answer.f3s","Answer.conditions"]
zscoreFields = ["Answer.f1probs", "Answer.f2probs", "Answer.f3probs"]

subjectIndices = []
itemIndices = []
zscoreIndices = []

f = open(sys.argv[1], "r")
firstline = 0
for l in f:
    l = l.strip()
    if firstline == 0:
        firstline = 1
        toks = l.split("\t")
        subjectIndices = [toks.index(s) for s in subjectFields]
        itemIndices = [toks.index(i) for i in itemFields]
        zscoreIndices = [toks.index(z) for z in zscoreFields]
        print "workerid,gender,age,income,categoryID,order,speaker,animal,f1,f2,f3,condition,f1prob,f2prob,f3prob"
    else:
        toks = l.split("\t")
        numItems = len(toks[itemIndices[0]].split(","))
        subjects = [toks[si] for si in subjectIndices]
        items = [toks[ii] for ii in itemIndices]
        allRatings = [float(raw) for raw in ",".join([toks[zz] for zz in zscoreIndices]).split(",")]
        tozscore = [toks[zz] for zz in zscoreIndices]
        mean = meanstdv(allRatings)[0]
        stdv = meanstdv(allRatings)[1]
        #print mean
        for j in range(numItems):
            itemstoprint = []
            for item in items:
                itemstoprint.append(item.split(",")[j])
            for rating in tozscore:
                itemstoprint.append(str((float(rating.split(",")[j]) - mean) / stdv))
            print ",".join(subjects) + "," + ",".join(itemstoprint)
