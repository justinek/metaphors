import sys, re, string

names = open(sys.argv[1], "r")

for name in names:
    name = name.strip()
    writeF = open("CombinedOutputMetaphor/" + name + ".csv", "w")
    for i in range(1, 33):
        filename = name + "-ID-" + str(i) + ".church"
        f = open("ParsedOutputMetaphor/" + filename, "r")
        for l in f:
            l = l.strip()
            writeF.write(l + "," + str(i) + "\n")
    writeF.close()
