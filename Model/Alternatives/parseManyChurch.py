import sys, re, string

print "categoryID,qud,category,f1,f2,f3,prob"

for qud in ["qud", "noQud"]:
    if qud == "qud":
        marker = "1"
    else:
        marker = "0"
    for catID in range(1, 33):
        f = open("ModelOutput/" + str(catID) + "-" + qud + ".txt", "r")
        for l in f:
            l = l.strip()
            pairs = l.split(")) (")
            values = pairs[1].replace(")", "").replace("(", "").split()
            conditions = pairs[0].split(") (")
            for i in range(len(conditions)):
                condition = conditions[i].replace("(", "").replace(")", "").replace(" ", ",")
                print str(catID) + "," + marker + "," + condition + "," + values[i]

