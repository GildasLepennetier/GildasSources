#!/usr/bin/python
import sys,numpy,os.path
if len(sys.argv) != 2:
	sys.stderr.write("Error: you have to give 1 argument: the file name, or - for stdin\n")
	exit(1)

LEN=[]

if sys.argv[1] == '-':
	k=0
	for rline in sys.stdin.readlines():
		line=rline.strip()
		if line[0]=='@':
			k=0
		if k == 1:
			LEN.append(len(line))
		k+=1
else:
	if os.path.isfile(sys.argv[1]):
		with open(sys.argv[1], 'r') as fi:
			for rline in fi.readlines():
				line=rline.strip()
				if line[0]=='@':
					k=0
				if k == 1:
					LEN.append(len(line))
				k+=1
	else:
		sys.stderr.write("Error: not a file %s\n"%(sys.argv[1]))
		exit(1)
if len(LEN)>0:
	print ( "nb of reads: %s"%(len(LEN)))
	print ( "min length: %s"%(min(LEN)))
	print ( "max length: %s"%(max(LEN)))
	NP=numpy.array(LEN)
	print ( "mean: %s"%(numpy.mean((LEN))))
	print ( "median: %s"%(numpy.median((LEN))))
else:
	sys.stderr.write("Error: empry file %s\n"%(sys.argv[1]))
	exit(1)
