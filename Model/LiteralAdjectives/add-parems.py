# add alpha, goal priors, and category priors

import sys, re, string, math

def makeParemsByInc(x, y, jump):
    parems = list()
    while x <= y:
        parems.append(x)
        x += jump
    return parems

def makeParemsByScale(x, y, jump):
    parems = list()
    while x <= y:
        parems.append(x)
        x *= jump
    return parems

# if qud, vary goal priors; otherwise make goal priors 0.33 
qud = int(sys.argv[1])

baselineQud = 0.5

if qud == 0:
    qudPriors = [0]
else:
    qudPriors = [0.1, 0.5]
    #qudPriors = makeParemsByInc(0.1, 0.5, 0.2)

alphaPriors = [1, 3]
#alphaPriors = makeParemsByInc(3, 4, 1)
#categoryPriors = range(2, 5) 

#print qudPriors
#print alphaPriors
#print categoryPriors

for qP in qudPriors:
    qParem = "(define (goal-prior) (multinomial goals '(" + str(baselineQud + qP) + " " + str(baselineQud) + " " + str(baselineQud) + " " + str(baselineQud + qP) + " " + str(baselineQud + qP) + " " + str(baselineQud) + " " + str(baselineQud + qP) + ")))"
    for aP in alphaPriors:
        aParem = "(define alpha " + str(aP) + ")"
        if qud == 0:
            paremStr = "noQud-a" + str(aP)
        else:
            paremStr = "g" + str(qP) + "-a" + str(aP)
        for i in range(1, 33):
            filename = paremStr + "-ID-" + str(i) + ".church"
            #print filename
            f = open("WithPriorsMetaphor/ID-" + str(i) + ".church", "r")
            writeF = open("WithParemsMetaphor/" + filename, "w")
            writeF.write(qParem + "\n" + aParem  + "\n")
            for l in f:
                writeF.write(l)

