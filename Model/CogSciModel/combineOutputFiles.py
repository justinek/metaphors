import sys, re, string

names = open(sys.argv[1], "r")

for name in names:
    name = name.strip()
    writeF = open("CombinedOutput/" + name + ".csv", "w")
    for i in range(1, 33):
        filename = name + "-ID-" + str(i) + ".church"
        f = open("ParsedOutput/" + filename, "r")
        for l in f:
            l = l.strip()
            writeF.write(l + "," + str(i) + "\n")
    writeF.close()
