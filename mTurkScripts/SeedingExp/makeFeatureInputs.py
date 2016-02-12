import sys, re, string

f = open(sys.argv[1], "r")

firstline = 0
for l in f:
    if firstline == 0:
        firstline = 1
    else:
        l = l.strip()
        toks = l.split(",")
        featureID = toks[0]
        feature = toks[1]
        print '{"featureID":' + str(featureID) +',"feature":"' + feature +  '"},' 
