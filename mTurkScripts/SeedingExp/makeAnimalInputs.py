import sys, re, string

f = open(sys.argv[1], "r")

firstline = 0
for l in f:
    if firstline == 0:
        firstline = 1
    else:
        l = l.strip()
        toks = l.split(",")
        animalID = toks[0]
        animal = toks[1]
        print '{"animalID":' + str(animalID) +',"animal":"' + animal +  '"},' 
