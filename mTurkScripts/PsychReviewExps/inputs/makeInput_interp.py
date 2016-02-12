import sys, re, string

f = open(sys.argv[1], "r")
antonymF = open("featuresAntonyms.csv", "r")

antonymDict = dict()
for l in antonymF:
	l = l.strip()
	toks = l.split(",")
	antonymDict[toks[0]] = toks[1]


for l in f:
	l = l.strip()
	toks = l.split("\t")
	ID = toks[0]
	animal = toks[1]
	features = toks[2].split(",")
	alternatives = toks[3].split(",")
	alt = alternatives[0]
	f1 = features[0]
	f2 = features[1]
	f1_not = antonymDict[f1]
	f2_not = antonymDict[f2]
	featureSets = [f1 + "; " + f2, f1 + "; " + f2_not,  f1_not + "; " + f2, f1_not + "; " + f2_not]
	det = "a"
	if animal[0] in ["a", "e", "i", "o", "u"]:
		det = "an"
	print '{"categoryID":' + ID + ',"animal":"' + animal + '", "alternative":"' + animal + '", "animalType":"orig", "f1":"' + f1 + '", "f2":"' + f2 + '","determiner":"' + det + '", "set1":"' + featureSets[0] + '", "set2":"' + featureSets[1] + '", "set3":"' + featureSets[2] + '", "set4":"' + featureSets[3] + '"},'
	det = "a"
	if alt[0] in ["a", "e", "i", "o", "u"]:
		det = "an"
	print '{"categoryID":' + ID + ',"animal":"' + animal + '", "alternative":"' + alt + '", "animalType":"alt", "f1":"' + f1 + '", "f2":"' + f2 + '","determiner":"' + det + '", "set1":"' + featureSets[0] + '", "set2":"' + featureSets[1] + '", "set3":"' + featureSets[2] + '", "set4":"' + featureSets[3] + '"},'
