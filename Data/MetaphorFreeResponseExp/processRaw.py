# trims down raw data file to include only relevant information
# removes and replaces excess symbols, punctuations, etc

import sys, re, string

f = open(sys.argv[1], "r")

# define the fields to keep
relevant_fields = ["workerid", "Answer.gender", "Answer.age", "Answer.income", "Answer.nativeLanguage", "Answer.conditions", "Answer.orders", "Answer.categoryIDs", "Answer.speakers", "Answer.animals","Answer.f1s", "Answer.f2s", "Answer.f3s"]
relevant_indices = []

#field that needs to be specially processed
special_fields = ["Answer.att1s", "Answer.att2s", "Answer.att3s"]
special_indices = []

firstline = 0
workerID = 1
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
            fieldToPrint = toks[i].replace('"",""', '"";""').replace(',', " ").replace('"";""', '"",""').replace('"', "").lower()
            fieldsToPrint.append(fieldToPrint)
        print "\t".join(fieldsToPrint)



