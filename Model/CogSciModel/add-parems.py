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

if qud == 0:
    qudPriors = makeParemsByInc(0.33, 0.33, 1)
else:
    qudPriors = makeParemsByInc(0.5, 1, 0.1)

alphaPriors = makeParemsByInc(3.5, 7, 0.5)
categoryPriors = range(2, 5) 

#print qudPriors
#print alphaPriors
#print categoryPriors

for qP in qudPriors:
    qPother = float((1 - qP) / 2)
    qParem = "(define (goal-prior) (multinomial goals '(" + str(qP) + " " + str(qPother) + " " + str(qPother) + ")))"
    for aP in alphaPriors:
        aParem = "(define alpha " + str(aP) + ")"
        for cP in categoryPriors:
            cPanimal = math.pow(10, -cP)
            cPperson = float(1) - cPanimal
            cParem = "(define (categories-prior) (multinomial categories '(" + str(cPanimal) + " " + str(cPperson) + ")))"
            if qud == 0:
                paremStr = "noQud-a" + str(aP) + "-c" + str(cP)
            else:
                paremStr = "g" + str(qP) + "-a" + str(aP) + "-c" + str(cP)
            for i in range(1, 33):
                filename = paremStr + "-ID-" + str(i) + ".church"
                #print filename
                f = open("WithPriors/ID-" + str(i) + ".church", "r")
                writeF = open("TempParems/" + filename, "w")
                writeF.write(qParem + "\n" + aParem + "\n" + cParem + "\n")
                for l in f:
                    writeF.write(l)

