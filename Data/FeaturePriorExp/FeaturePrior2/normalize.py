import sys, re, string

f = open(sys.argv[1], "r")

normalize_fields = ["set1prob", "set2prob", "set3prob", "set4prob"]
normalize_indices = []

firstline = 0
for l in f:
    l = l.strip()
    if firstline == 0:
        firstline = 1
        toks = l.split(",")
        for i in range(len(toks)):
            if toks[i] in normalize_fields:
                normalize_indices.append(i)
        print l
    else:
        toks = l.split(",")
        to_normalize = []
        for i in normalize_indices:
            to_normalize.append(float(toks[i]))
        normalizer = float(sum(to_normalize))
        normalized = []
        for i in range(len(toks)):
            if i in normalize_indices:
                field = str(float(toks[i])/ normalizer)
            else:
                field = toks[i]
            normalized.append(field)
        print ",".join(normalized)
    
        

