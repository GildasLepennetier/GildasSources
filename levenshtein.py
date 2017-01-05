#!/usr/bin/env python

# Christopher P. Matthews
# christophermatthews1985@gmail.com
# Sacramento, CA, USA
import sys,argparse

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
	
	parser = argparse.ArgumentParser(description="Calculate the Levenshtein distance between two strings.",epilog='Author: Gildas Lepennetier')
	parser.add_argument('-s1',type=str,required=True,help='Sequence 1')
	parser.add_argument('-s2',type=str,required=True,help='Sequence 2')

	parser.add_argument('-i',action='store_true',default=False,help='To make the function case insensitive')
	parser.add_argument('--version', action='version', version='%(prog)s 2017')#version display
	parser.add_argument('--copy',action='store_true',help='Display Copyright informations')
	parser.add_argument('--author',action='store_true',help='Display author informations')
	args=vars(parser.parse_args())
	
	if args['author']:
		print ("LEPENNETIER Gildas - gildas.lepennetier@hotmail.fr")
		exit()
	if args['copy']:
		print ("Copyright 2014 LEPENNETIER Gildas")
		exit()
	if args['i']:
		args['s1']=args['s1'].upper()
		args['s2']=args['s2'].upper()
		
	print(levenshtein( args['s1'], args['s2']))