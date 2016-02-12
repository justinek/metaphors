import sys, re, string

f = open(sys.argv[1], "r")

subjectFields = ["workerid", "Answer.gender", "Answer.nativeLanguage", "Answer.income", "Answer.age"]
itemFields = ["Answer.orders", "Answer.animalIDs", "Answer.animals", "Answer.adjectives"]

print "workerid,gender,language,income,age,order,animalID,animal,adjective"

firstline = 0
for l in f:
    if firstline == 0:
        firstline = 1
    else:
        l = l.strip()
        toks = l.split("\t")
        subjects = toks[0:5]
        items = toks[5:]
        numTrials = len(items[0].split(","))
        for i in range(numTrials):
            toPrint = []
            for j in range(len(items)):
                item = items[j].split(",")[i].lower()
                toPrint.append(item)
            print ",".join(subjects) + "," + ",".join(toPrint)

