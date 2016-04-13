import sys, re, string

f = open(sys.argv[1], "r")

namesDict = dict()
for l in f:
    l = l.strip()
    toks = l.split("-ID-")
    name = toks[0]
    #end = "-".join(toks[1].split("-")[1:3]).replace(".church", "")
    namesDict[name] = 0

for key in namesDict.keys():
    print key
    
