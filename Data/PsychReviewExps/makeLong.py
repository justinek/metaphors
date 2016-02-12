import sys, re, string

def normalize(vector):
    denom = sum(map(float, vector))
    normalized = [float(x) / denom for x in vector]
    return map(str, normalized)

f = open(sys.argv[1], "r")

subject_indices = range(0,5)
item_indices = range(5,13)
#normalize_indices = range(22, 32)

# Order of the fields
print "workerID,gender,age,income,language,order,item,utteranceType,quality,dimension,speakerGender,describedGender,response"
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
                print ",".join([toks[i] for i in subject_indices]) + "," + ",".join([toks[i].split(",")[trial] for i in item_indices]) 
