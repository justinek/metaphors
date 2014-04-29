import sys, re, string

f = open("unique-features.txt", "r")

firstline = 0
for l in f:
    l = l.strip()
    if firstline == 0:
        firstline = 1
    else:
        print '{"feature":"' + l + '"},'

