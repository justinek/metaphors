import sys, re, string

subjectFields = ["workerid", "Answer.gender", "Answer.age", "Answer.income"]
itemFields = ["Answer.categoryIDs", "Answer.orders", "Answer.animals", "Answer.names", "Answer.set1probs_animals", "Answer.set2probs_animals", "Answer.set3probs_animals", "Answer.set4probs_animals", "Answer.set5probs_animals", "Answer.set6probs_animals", "Answer.set7probs_animals", "Answer.set8probs_animals","Answer.set1probs_people", "Answer.set2probs_people", "Answer.set3probs_people", "Answer.set4probs_people", "Answer.set5probs_people", "Answer.set6probs_people", "Answer.set7probs_people", "Answer.set8probs_people"]

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
        print "workerid,gender,age,income,categoryID,order,animal,name,a_1,a_2,a_3,a_4,a_5,a_6,a_7,a_8,p_1,p_2,p_3,p_4,p_5,p_6,p_7,p_8"
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
