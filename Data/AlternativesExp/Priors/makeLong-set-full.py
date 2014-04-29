import sys, re, string

subjectFields = ["workerid", "Answer.gender", "Answer.age", "Answer.income"]
itemFields = ["Answer.categoryIDs", "Answer.orders", "Answer.animals", "Answer.featureNums","Answer.alternatives","Answer.set1probs_animals", "Answer.set2probs_animals", "Answer.set3probs_animals", "Answer.set4probs_animals", "Answer.set5probs_animals", "Answer.set6probs_animals", "Answer.set7probs_animals", "Answer.set8probs_animals"]

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
        print "workerid,gender,age,income,categoryID,order,animal,featureNum,alternative,1,2,3,4,5,6,7,8"
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
