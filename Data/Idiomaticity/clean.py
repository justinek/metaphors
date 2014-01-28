import sys, re, string
# cleans up file into readable format
f = open(sys.argv[1], "r")

for l in f:
    l = l.strip()
    toks=l.split("\t")
    print ",".join(toks)
