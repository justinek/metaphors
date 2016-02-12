# for each of the 39 total animals (Animals/allAnimals.csv)
# find curated 2 core features using Features/allFeatures_givenAnimals.csv.
# For each of the features, find alernatives using Animals/allAnimals_givenFeatures.csv.
# For each of the alternatives, find alternative features using Features/allFeatures_givenAnimals.csv.
# For each of the expanded features for a given animal, print out alternatives + animal

animalsF = open("Animals/allAnimals.csv", "r")
featuresF = open("Features/allFeatures_givenAnimals.csv", "r")
alternativesF = open("Animals/allAnimals_givenFeatures.csv", "r")

featureDict = dict()
alternativeDict = dict()

firstline = 0
for l in featuresF:
    if firstline == 0:
        firstline = 1
    else:
        l = l.strip()
        toks = l.split(",")
        animal = toks[1]
        feature = toks[2]
        if animal not in featureDict:
            featureDict[animal] = [feature]
        else:
            featureDict[animal].append(feature)

firstine = 0
for l in alternativesF:
    if firstline == 0:
        firstline = 1
    else:
        l = l.strip()
        toks = l.split(",")
        feature = toks[1]
        animal = toks[2]
        if feature not in alternativeDict:
            alternativeDict[feature] = [animal]
        else:
            alternativeDict[feature].append(animal)

#print alternativeDict
firstline = 0
print "animal,feature,alternatives,numAlts"
for l in animalsF:
    if firstline == 0:
        firstline = 1
    else:
        l = l.strip()
        toks = l.split(",")
        animal = toks[1]
        core_features = featureDict[animal]
        alternatives = []
        alternative_features = []
        #print core_features
        for core_feature in core_features:
            if core_feature in alternativeDict:
                alternatives = alternatives + alternativeDict[core_feature]
        alternatives = list(set(alternatives + [animal]))
        #print alternatives
        for alternative in alternatives:
            alternative_features = alternative_features + featureDict[alternative]
        alternative_features = list(set(alternative_features))
        alternatives = alternatives + ["man"]

        for alternative_feature in alternative_features:
            print animal + "," + alternative_feature + "," + ";".join(alternatives) + "," + str(len(alternatives))
        #print animal
        #print core_features
        #print alternatives
        #print alternative_features
        #print animal + "," + ";".join(alternatives) + "," + ";".join(alternative_features) + "," + str(len(alternatives)) + "," + str(len(alternative_features))
