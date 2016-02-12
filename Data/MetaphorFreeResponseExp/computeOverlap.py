import sys, re, string

f = open(sys.argv[1], "r")

print "condition,animal,originalFeatures,numOverlap,extras"
firstline = 0
for l in f:
    l = l.strip()
    if firstline == 0:
        firstline = 1
    else:
        toks = l.split(",")
        condition = toks[5]
        animal = toks[9]
        originalFeatures = toks[10:13]
        interpretedFeatures = toks[13:16]
        numOverlap = 0
        extras = []
        for i in interpretedFeatures:
            if i in originalFeatures:
                numOverlap = numOverlap + 1
            else:
                extras.append(i)
        print condition + "," + animal + "," + ";".join(originalFeatures) + "," + str(numOverlap) + "," + ";".join(extras)
        
