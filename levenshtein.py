#!/usr/bin/env python

# Christopher P. Matthews
# christophermatthews1985@gmail.com
# Sacramento, CA, USA
import sys

def levenshtein(s, t):
        ''' From Wikipedia article; Iterative with two matrix rows. '''
        if s == t: return 0
        elif len(s) == 0: return len(t)
        elif len(t) == 0: return len(s)
        v0 = [None] * (len(t) + 1)
        v1 = [None] * (len(t) + 1)
        for i in range(len(v0)):
            v0[i] = i
        for i in range(len(s)):
            v1[0] = i + 1
            for j in range(len(t)):
                cost = 0 if s[i] == t[j] else 1
                v1[j + 1] = min(v1[j] + 1, v0[j + 1] + 1, v0[j] + cost)
            for j in range(len(v0)):
                v0[j] = v1[j]
        return v1[len(t)]
if __name__ == "__main__":
	if len(sys.argv) < 3:
		print ("Error: too few argument")
		print ("usage: levenshtein string1 string2")
	elif len(sys.argv) > 3:
		print ("Error: too many argument")
		print ("usage: levenshtein <string1> <string2>")
	elif len(sys.argv) == 3:
		print(levenshtein(sys.argv[1],sys.argv[2]))