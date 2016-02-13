import sys, re, string

# For each target utterance, find set of alternatives and
# set of features to consider

priorsF = open("../../Data/SeedingPriorExp/priors_6bins.csv", "r")

numBins = 0
priorsDict = dict()
firstline = 0
for l in priorsF:
    if firstline == 0:
        firstline = 1
    else:
        l = l.strip()
        toks = l.split(",")
        numBins = len(toks) - 3
        feature = toks[1]
        animal = toks[2]
        bins = toks[3:]
        if feature not in priorsDict:
            animalDict = dict()
            priorsDict[feature] = animalDict
        priorsDict[feature][animal] = bins

humanPrior = 0.99
alphas = [1, 2, 3]

for alpha in alphas:
    targetF = open("../../Data/SeedingExp/animals_alternatives_features_sorted_coreAnimals.csv", "r")

    firstline = 0
    for l in targetF:
        if firstline == 0:
            firstline = 1
        else:
            l = l.strip()
            toks = l.split(",")
            utterance = toks[1]
        
            alternatives = toks[2].split(";")
            alternativeProbs = []
            costs = []
            for i in range(len(alternatives)):
                costs.append("1")
                if alternatives[i] == "man":
                    alternativeProbs.append(str(humanPrior))
                else:
                    alternativeProbs.append(str((1-humanPrior) / (len(alternatives) - 1)))
            features = toks[3].split(";")
            writeF = open("CoreAnimals/" + utterance + "_" + str(numBins) + "_" + str(alpha) + ".church", "w")
            writeF.write("(define categories (list '" + " '".join(alternatives) + "))\n")
            writeF.write("(define (categories-prior) (multinomial categories '(" + " ".join(alternativeProbs) + ")))\n")
            writeF.write("(define utterances categories)\n")
            writeF.write("(define costs '(" + " ".join(costs) + "))\n")
            writeF.write("(define (utterance-prior) (multinomial utterances (map (lambda (utterance-cost) (exp (- utterance-cost))) costs)))\n")
            goals = ["'category?"]
            for feature in features:
                goals.append("'" + feature + "?")
                writeF.write("(define " + feature + " (list " + " ".join(map(str, range(numBins))) + "))\n")
                writeF.write("(define (" + feature + "-prior category)\n")
                writeF.write("(case category\n")
                for alternative in alternatives:
                    writeF.write("\t(('" + alternative + ") (multinomial " + feature + " (list " + " ".join(map(str, priorsDict[feature][alternative])) + ")))\n")         
                writeF.write("))\n")

            writeF.write("(define goals (list " + " ".join(goals) + "))\n")
            writeF.write("(define (goal-prior) (uniform-draw goals))\n")
            #writeF.write("(define (goal-satisfied? goal listener-world speaker-world)\n")
            #writeF.write("(case goal\n")
            #for i in range(len(goals)):
            #    writeF.write("\t((" + goals[i] + ") (equal? (list-ref listener-world " + str(i) + ") (list-ref speaker-world " + str(i) + ")))\n")
            #writeF.write("))\n")
            #writeF.write("(define (literal-interpretation utterance category) (equal? utterance category))\n")
            writeF.write("(define lit-listener (mem (lambda (utterance goal)\n")
            writeF.write("(enumeration-query\n")
            writeF.write("(define category utterance)\n")
            writeF.write("(define feature\n")
            writeF.write("\t(case goal\n")
            writeF.write("\t\t(('category?) category)\n")
            for feature in features:
                writeF.write("\t\t(('" + feature + "?) (" + feature + "-prior category))\n")
            writeF.write("))\n")
            writeF.write("feature\n")
            #writeF.write("(list category " + " ".join(features) + ")\n")
            writeF.write("#t))))\n")
            writeF.write("(define speaker (mem (lambda \n")
            writeF.write("(category " + " ".join(features) + " goal)\n")
            writeF.write("(enumeration-query\n")
            writeF.write("(define utterance (utterance-prior))\n")
            writeF.write("(define dimension\n")
            writeF.write("\t(case goal\n")
            writeF.write("\t\t(('category?) category)\n")
            for feature in features:
                writeF.write("\t\t(('" + feature + "?) " + feature + ")\n")

            writeF.write("))\n")
            writeF.write("utterance\n")
            #writeF.write("(goal-satisfied? goal (apply multinomial (lit-listener utterance)) (list category " + " ".join(features) + "))))))\n")
            writeF.write("(equal? (apply multinomial (lit-listener utterance goal)) dimension)))))\n")
            writeF.write("(define listener (mem (lambda (utterance)\n")
            writeF.write("(enumeration-query\n")
            writeF.write("(define category (categories-prior))\n")
            for feature in features:
                writeF.write("(define " + feature + " (" + feature + "-prior category))\n")
            writeF.write("(define speaker-goal (goal-prior))\n")
            writeF.write("(list category " + " ".join(features) + ")\n")
            writeF.write("(equal? utterance (apply multinomial (raise-to-power (speaker category " + " ".join(features) + " speaker-goal) alpha)))))))\n")
            writeF.write("(define (raise-to-power speaker-dist alpha) (list (first speaker-dist) (map (lambda (x) (pow x alpha)) (second speaker-dist))))\n")
            #writeF.write("(define depth 1)\n")
            writeF.write("(define alpha " + str(alpha) + ")\n")
            writeF.write("(define interpretation (listener '" + utterance + "))\n")
            writeF.write("(write-csv (map flatten (zip (first interpretation) (second interpretation))) '/Users/justinek/Dropbox/Work/Grad_school/Research/Metaphor/metaphors/Model/SeedingModel/CoreAnimalsOutput/" + utterance + "_" + str(numBins) + "_" + str(alpha) + ".csv)")
    targetF.close()        
