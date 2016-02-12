import sys, re, string
from nltk.corpus import wordnet as wn

def checkOverlap(list1, list2):
    for l1 in list1:
        if l1 in list2:
            return True
    return False

f = open(sys.argv[1], "r")

dictionary = dict()
mapping = dict()

firstline = 0
for l in f:
    if firstline == 0:
        firstline = 1
    else:
        l = l.strip()
        toks = l.split(",")
        feature = toks[0]
        freq = int(toks[1])
        synsets = wn.synsets(feature)
        syns_freq = [synsets, freq]
        dictionary[feature] = syns_freq
        
for feature1, syns_freq in dictionary.iteritems():
    synonym = ""
    for feature2 in dictionary.keys():
        syns1 = dictionary[feature1][0]
        syns2 = dictionary[feature2][0]
        freq1 = dictionary[feature1][1]
        freq2 = dictionary[feature2][1]
        #print feature1
        #print syns1
        #print feature2
        #print syns2
        if checkOverlap(syns1, syns2) and freq1 < freq2:
            synonym = feature2
    if synonym == "":
        mapping[feature1] = feature1
    else:
        mapping[feature1] = synonym

#print mapping

data = open(sys.argv[2], "r")

firstline = 0
for l in data:
    l = l.strip()
    if firstline == 0:
        firstline = 1
        print l + "," + "synonym"
    else:
        toks = l.split(",")
        word = toks[8]
        syn = mapping[word]
        print ",".join(toks) + "," + syn
