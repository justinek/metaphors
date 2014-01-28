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
itemFields = ["Answer.categoryIDs","Answer.orders","Answer.animals","Answer.names"]
zscoreFields = ["Answer.set1probs_animals", "Answer.set2probs_animals", "Answer.set3probs_animals", "Answer.set4probs_animals", "Answer.set5probs_animals", "Answer.set6probs_animals", "Answer.set7probs_animals", "Answer.set8probs_animals","Answer.set1probs_people", "Answer.set2probs_people", "Answer.set3probs_people", "Answer.set4probs_people", "Answer.set5probs_people", "Answer.set6probs_people", "Answer.set7probs_people", "Answer.set8probs_people"]
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
        print "workerid,gender,age,income,categoryID,order,animal,name,a_1,a_2,a_3,a_4,a_5,a_6,a_7,a_8,p_1,p_2,p_3,p_4,p_5,p_6,p_7,p_8"
    else:
        toks = l.split("\t")
        numItems = len(toks[itemIndices[0]].split(","))
        subjects = [toks[si] for si in subjectIndices]
        items = [toks[ii] for ii in itemIndices]
        allRatings = [float(raw) for raw in ",".join([toks[zz] for zz in zscoreIndices]).split(",")]
        tozscore = [toks[zz] for zz in zscoreIndices]
        mean = meanstdv(allRatings)[0]
        stdv = meanstdv(allRatings)[1]
        for j in range(numItems):
            itemstoprint = []
            for item in items:
                itemstoprint.append(item.split(",")[j])
            for rating in tozscore:
                itemstoprint.append(str((float(rating.split(",")[j]) - mean) / stdv))
            print ",".join(subjects) + "," + ",".join(itemstoprint)
