import sys, re, string

categories = [[0.9, 0.8, 0.01],[0.01, 0.8, 0.99]]
featureSets = [[1,1,0],[1,0,0],[0,1,0],[0,0,0],[1,1,1],[1,0,1],[0,1,1],[0,0,1]]


#categories = [[0.9, 0.8],[0.01, 0.8]]
#featureSets =[[1,1],[1,0],[0,1],[0,0]]

for category in categories:
    for features in featureSets:
        prob = 1
        for i in range(len(features)):
            if features[i] == 1:
                prob = prob * category[i]
            else:
                prob = prob * (1-category[i])
        print str(prob) + " ",
    print "\n",

