# starting with the 12 core animals and the 2 features each
# find 2 additional animals associated with each of the 2 features
# enforce each core animal to have 2 features
# and 4 alterantive animals

import sys, re, string, operator
from sets import Set

# core animals and 2 featurers each
coreF = open("../../Data/Features0/features0_curated.csv", "r")

coreDict = dict()

for l in coreF:
	l = l.strip()
	toks = l.split(",")
	animal = toks[1]
	feature = toks[2]
	if animal in coreDict:
		features = coreDict[animal]
		features.append(feature)
		coreDict[animal] = features
	else:
		features = [feature]
		coreDict[animal] = features

# animals given each of the core features
altF = open("../../Data/Animals1/animals1_tally_byFeature.csv", "r")

altDict = dict()
firstline = 0
for l in altF:
	if firstline == 0:
		firstline = 1
	else:
		toks = l.split(",")
		feature = toks[1]
		animal = toks[2]
		count = int(toks[3])
		if feature in altDict:
			animals = altDict[feature]
			animals[animal] = count
			altDict[feature] = animals
		else:
			animals = dict()
			animals[animal] = count
			altDict[feature] = animals

# animals given each of the core animals
altPerAnimal = dict()

for a, f in coreDict.iteritems():
	#print a
	#print f
	alternatives = Set([a])
	f1 = f[0]
	f2 = f[1]
	a1s = [animal[0] for animal in sorted(altDict[f1].items(), key=operator.itemgetter(1), reverse=True)]
	a2s = [animal[0] for animal in sorted(altDict[f2].items(), key=operator.itemgetter(1), reverse=True)]
	i = 0
	while len(alternatives) < 5:
		a1 = a1s[i]
		a2 = a2s[i]
		alternatives.add(a1)
		if len(alternatives) < 5:
			alternatives.add(a2)
		i = i + 1
	#altPerAnimal[a] = alternatives
	alternatives.add("man")
	altPerAnimal[a] = alternatives

coreF = open("../../Data/Features0/features0_curated.csv", "r")
ids = []
for l in coreF:
	l = l.strip()
	toks = l.split(",")
	ID = toks[0]
	if ID not in ids:
		ids.append(ID)
		animal = toks[1]
		features = coreDict[animal]
		alternatives = altPerAnimal[animal]
		print ID + "\t" + animal + "\t" + ",".join(features) + "\t" + ",".join(alternatives)
#print coreDict
#print coreDict
#print altPerAnimal







#print altDict

#print coreDict
#for k, v in coreDict.iteritems():
#	print k + "\t" + ",".join(v)
