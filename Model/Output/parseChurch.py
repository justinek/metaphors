import sys, re, string

f = open(sys.argv[1], "r")

for l in f:
    l = l.strip()
    pairs = l.split(")) (")
    values = pairs[1].replace(")", "").replace("(", "").split()
    conditions = pairs[0].split(") (")
    for i in range(len(conditions)):
        condition = conditions[i].replace("(", "").replace(")", "").replace(" ", ",")
        print condition + "," + values[i]

