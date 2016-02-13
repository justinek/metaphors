import sys, re, string

alphas = [1, 2, 3, 4, 5, 6]
cost_diffs = [0, 0.1, 0.2]

for alpha in alphas:
    for diff in cost_diffs:
        filename = "ModelsWithParams_YesNo/" +  str(alpha) + "-" + str(diff) + ".church"
        wf = open(filename, "w")
        wf.write("(define alpha " + str(alpha) + ")\n(define cost-diff " + str(diff) + ")\n")
        f = open(sys.argv[1], "r")
        for l in f:
            wf.write(l)
        f.close()
        wf.close()



