import sys, re, string

f = open(sys.argv[1], "r")

for l in f:
    l = l.strip()
    newl = l.replace('"', "")
    toks = newl.split("set1:")
    l = l.replace("},", "")
    f1 = toks[1].split(", ")[0]
    print l + '"f1":"' + f1 + '"},'
