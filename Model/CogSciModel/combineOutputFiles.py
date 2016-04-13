import sys, re, string

names = open(sys.argv[1], "r")

for name in names:
    name = name.strip()
    writeF = open("CombinedOutputLambdaParems/" + name + "-plaw-highlaw.csv", "w")
    for i in range(1, 33):
        filename = name + "-ID-" + str(i) + "-plaw-highlaw.church"
        f = open("ParsedOutputLambdaParems/" + filename, "r")
        for l in f:
            l = l.strip()
            writeF.write(l + "," + str(i) + "\n")
    writeF.close()
