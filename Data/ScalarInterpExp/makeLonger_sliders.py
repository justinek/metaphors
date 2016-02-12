import sys, re, string

f = open(sys.argv[1], "r")

subject_indices = range(0,12)
bin_indices = range(12,22)
prior_indices = range(22, 32)

# Order of the fields
print "workerID,gender,age,income,language,order,item,dimension,literal,quality,speaker,person,bin,bin_num,prob"

firstline = 0
for l in f:
    if firstline == 0:
        firstline = 1
    else:
        if "null" not in l:
            l = l.strip().replace('"', "")
            toks = l.split(",")
            numTrials = len(bin_indices)
            # Make vector of all responses in a single trial
            for trial in range(numTrials):
                print ",".join([toks[i] for i in subject_indices]) + "," + toks[bin_indices[trial]] + "," + str(trial) + "," + toks[prior_indices[trial]]
