#
# this script takes a file from pRESTO like _clone-pass_germ-pass.tab
# using the CLONE (column 46 in pthon index), it search for V_CALL attribution (column 7)
# then, if there are several attribution, they are joined by coma, and multiple is set to True
# allows to find the germline sequence a bit more easily
#

import sys
linenb=0
CLONES_CALL={}
CLONES_GENE={}
CLONES_COUNT={}
with open(sys.argv[1]) as File:
	for rline in File.readlines():
		line=rline.split('\n')[0].split('\t')
		linenb+=1
		if linenb == 1: continue #to skip header
		CLONE=line[46]
		if CLONE not in CLONES_COUNT.keys():
			CLONES_COUNT[CLONE]=1
		else:
			CLONES_COUNT[CLONE]+=1
		CALLS=line[7].split(',')
		for CALL in CALLS:
			if CLONE not in CLONES_GENE.keys():
				CLONES_GENE[CLONE]=[CALL]
			else:
				if CALL not in CLONES_GENE[CLONE]:
					CLONES_GENE[CLONE].append(CALL)
			c=CALL.split('-')[0]
			if CLONE in CLONES_CALL.keys():
				if c not in CLONES_CALL[CLONE]: 
					CLONES_CALL[CLONE].append(c)
			else:
				CLONES_CALL[CLONE]=[c] #make a list
	#output
	print("CLONE\tCALL\tMULTIPLE_CALL\tCLONE_COUNT\tGENE\tMULTIPLE_GENE")
	for CLONE in CLONES_CALL.keys():
		Multi_CALL=False
		if len(CLONES_CALL[CLONE]) > 1:
			Multi_CALL=True
		Multi_GENE=False
		if len(CLONES_GENE[CLONE]) > 1:
			Multi_GENE=True
		print("%s\t%s\t%s\t%s\t%s\t%s"%(CLONE, ",".join( CLONES_CALL[CLONE]), Multi_CALL, CLONES_COUNT[CLONE], ",".join( CLONES_GENE[CLONE]),Multi_GENE ))
