import sys, re, string

f = open(sys.argv[1], "r")

profession_list = list()
for l in f:
    l = l.strip().lower()
    profession_list.append(l)

for p1 in profession_list:
    for p2 in profession_list:
        if p1 is not p2:
            article = "a"
            if p2[0] in ['a','e','i','o','u']:
                article = "an"
            print "That " + p1 + " is " + article + " " + p2 + "."
