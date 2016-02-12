# trims down raw data file to include only relevant information
# removes and replaces excess symbols, punctuations, etc

import sys, re, string

f = open(sys.argv[1], "r")

# define the fields to keep
relevant_fields = ["workerid", "Answer.gender", "Answer.age", "Answer.income", "Answer.nativeLanguage", "Answer.orders", "Answer.categoryIDs", "Answer.animals", "Answer.conditions", "Answer.set1probs", "Answer.set2probs", "Answer.set3probs", "Answer.set4probs"] 
relevant_indices = []

special_fields =  ["Answer.set1s", "Answer.set2s", "Answer.set3s", "Answer.set4s"]
special_indices = []

firstline = 0
for l in f:
    l = l.strip()
    l = l.replace("[", "")
    l = l.replace("]", "")
    if firstline == 0:
        l = l.replace('"', "")
        toks = l.split("\t")
        for field in relevant_fields:
            relevant_indices.append(toks.index(field))
        for field in special_fields:
            special_indices.append(toks.index(field))
        firstline = 1
        print "\t".join(relevant_fields) + "\t" + "\t".join(special_fields)
    else:
        toks = l.split("\t")
        fieldsToPrint = []
        for i in relevant_indices:
            fieldToPrint = toks[i].replace('"', "")
            fieldsToPrint.append(fieldToPrint)
        for i in special_indices:
            fieldToPrint = toks[i].replace('"', "").replace(", ", ";")
            fieldsToPrint.append(fieldToPrint)
        print "\t".join(fieldsToPrint)



