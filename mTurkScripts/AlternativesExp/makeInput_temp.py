import sys, re, string

f = open(sys.argv[1], "r")

categoryID = 1
for l in f:
    l = l.strip()
    print '{"categoryID":' + str(categoryID) + ',"animal":"' + l + '"},' 
    categoryID = categoryID + 1
