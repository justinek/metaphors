import sys, re, string

subjectFields = ["workerid", "Answer.gender", "Answer.age", "Answer.income"]
itemFields = ["Answer.categoryIDs","Answer.orders","Answer.animals","Answer.f1s","Answer.f2s","Answer.f3s","Answer.f1probs_animals" ,"Answer.f2probs_animals", "Answer.f3probs_animals", "Answer.f1probs_people", "Answer.f2probs_people", "Answer.f3probs_people"]

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
        print "workerid,gender,age,income,categoryID,order,animal,f1,f2,f3,f1prob_animal,f2prob_animal,f3prob_animal,f1prob_person,f2prob_person,f3prob_person"
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
