#!/usr/bin/python
import sys,os.path,argparse

parser = argparse.ArgumentParser(description="Tool for selection of fastq depending on sequence length",epilog='Author: Gildas Lepennetier')
parser.add_argument('-i', type=argparse.FileType('r'),default=sys.stdin, help='input file name, otherwise take from stdin')
parser.add_argument('-o', type=argparse.FileType('w'),default=sys.stdout, help='output file name, otherwise print in stdout')
parser.add_argument('-min',type=int,help='Minimum size of the sequence <integer>')
parser.add_argument('-max',type=int,help='Maximum size of the sequence <integer>')

args=vars(parser.parse_args())

k=0
for rline in args['i'].readlines():
	k+=1
	line=rline.strip()
	if line[0]=='@':
		k=1
		ID=line #store and wait for tests
	if k == 2:
		if args['min']:
			if len(line) < args['min']:
				continue
		if args['max']:
			if len(line) > args['max']:
				continue
		SEQ=line
	if k == 3:
		PLUS=line
		continue
	if k == 4:
		QUAL=line
		args['o'].write("%s\n%s\n%s\n%s\n"%(ID,SEQ,PLUS,QUAL))
	


