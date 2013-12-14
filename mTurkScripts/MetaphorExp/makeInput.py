import sys, re, string

f = open(sys.argv[1], "r")

categoryID = 1
for l in f:
    l = l.strip().lower()
    if l[0] in ["a", "e", "i", "o", "u"]:
        det = "an"
    else:
        det = "a"
    print '{"categoryID":' + str(categoryID) + ',"det":"' + det + '","animal":"' + l + '"},' 
    categoryID = categoryID + 1
