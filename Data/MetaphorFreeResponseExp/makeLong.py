import sys, re, string

f = open(sys.argv[1], "r")

subject_indices = range(0,5)
item_indices = range(5,16)

# Order of the fields
print "workerID,gender,age,income,language,condition,order,categoryID,speaker,animal,f1,f2,f3,att1,att2,att3"

firstline = 0
for l in f:
    if firstline == 0:
        firstline = 1
    else:
        l = l.strip().replace('"', "")
        toks = l.split("\t")
        numTrials = len(toks[item_indices[0]].split(","))
        
        # Make vector of all responses in a single trial
        for trial in range(numTrials):
            print ",".join([toks[i] for i in subject_indices]) + "," + ",".join([toks[i].split(",")[trial] for i in item_indices])
