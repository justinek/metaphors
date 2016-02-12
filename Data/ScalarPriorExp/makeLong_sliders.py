import sys, re, string

def normalize(vector):
    denom = sum(map(float, vector))
    normalized = [float(x) / denom for x in vector]
    return map(str, normalized)

f = open(sys.argv[1], "r")

subject_indices = range(0,5)
item_indices = range(5,18)
normalize_indices = range(18, 28)

# Order of the fields
print "workerID,gender,age,income,language,order,item,dimension,bin0,bin1,bin2,bin3,bin4,bin5,bin6,bin7,bin8,bin9,prior0,prior1,prior2,prior3,prior4,prior5,prior6,prior7,prior8,prior9"

firstline = 0
for l in f:
    if firstline == 0:
        firstline = 1
    else:
        if "null" not in l:
            l = l.strip().replace('"', "")
            toks = l.split("\t")
            numTrials = len(toks[item_indices[0]].split(","))
        
            # Make vector of all responses in a single trial
            for trial in range(numTrials):
                print ",".join([toks[i] for i in subject_indices]) + "," + ",".join([toks[i].split(",")[trial] for i in item_indices]) + ","  + ",".join(normalize([toks[i].split(",")[trial] for i in normalize_indices]))
