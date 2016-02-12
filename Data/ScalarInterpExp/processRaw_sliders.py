# trims down raw data file to include only relevant information
# removes and replaces excess symbols, punctuations, etc

import sys, re, string

f = open(sys.argv[1], "r")

# define the fields to keep
relevant_fields = ["workerid", "Answer.gender", "Answer.age", "Answer.income", "Answer.nativeLanguage", "Answer.orders", "Answer.items", "Answer.dimensions", "Answer.desTypes", "Answer.qualities", "Answer.speakerGenders", "Answer.genders", "Answer.bins0", "Answer.bins1", "Answer.bins2", "Answer.bins3", "Answer.bins4", "Answer.bins5", "Answer.bins6", "Answer.bins7", "Answer.bins8", "Answer.bins9", "Answer.priors0", "Answer.priors1", "Answer.priors2", "Answer.priors3", "Answer.priors4", "Answer.priors5", "Answer.priors6", "Answer.priors7", "Answer.priors8", "Answer.priors9"]

relevant_indices = []

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
        firstline = 1
        print "\t".join(relevant_fields)
    else:
        toks = l.split("\t")
        fieldsToPrint = []
        for i in relevant_indices:
            if i == relevant_indices[4]:
                fieldToPrint = toks[i].replace('"', "").replace(",", "_")
            else:
                fieldToPrint = toks[i].replace('"', "")
            fieldsToPrint.append(fieldToPrint)
        print "\t".join(fieldsToPrint)



