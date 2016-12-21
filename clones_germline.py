#!/usr/bin/env python
# open clone_table30.txt, open germline, print fasta from tab file (alml7d-F_clone-pass_germ-pass.tab)

import sys
SummaryPATH=sys.argv[1]
GermlinePATH=sys.argv[2]
TabFilePATH=sys.argv[3]

# insert in string, each X letter () perfect to format a fasta file with 80 nt per line
def insert_in_string(string,insert="\n",each=80):
	string2=""
	ii=0
	for letter in string:
		ii+=1
		if ii % each == 0 :
			string2=string2+letter
			string2=string2+insert
		else:
			string2=string2+letter
	return string2


#load the germlines - with proper name for genes
def loadFastaGermlineIMGT(adresse,eol="\n"):
	from Bio import SeqIO
	dico={}
	for seq_record in SeqIO.parse(adresse, 'fasta'):
		ID=str(seq_record.description.split('|')[1])
		SEQ=str( seq_record.seq.split(eol)[0] )
		if ID not in dico.keys():
			dico[ID]=SEQ
		else:
			print("ERROR: %s already exist as key!"%ID)
	return dico
GERMLINE=loadFastaGermlineIMGT(GermlinePATH)

#load Summary files
linecount=0

SUMMARY={}
with open(SummaryPATH,'r') as File:
	for rline in File.readlines():
		line=rline.split('\n')[0].split('\t')
		linecount+=1
		if linecount == 1: continue
		
		if line[2]=='False':
			CLONE=line[0]
			if CLONE not in SUMMARY.keys():
				SUMMARY[CLONE]=line
			else:
				sys.stderr.write("ERROR: summary file should not have duplicated clone ids, something is wrong...\n")
#load all tab
TABFILE=[]
with open(TabFilePATH,'r') as File:
	for rline in File.readlines():
		TABFILE.append( rline.split('\n')[0].split('\t') )

#make fasta using summary file with list of clones, V_call etc...

# in TAB file
index_CLONE=46
index_CDR3=45
index_SeqID=0

# in summary file
index_CALL=1
index_GENE=4
index_GENE_multi=5


for CLONE in SUMMARY.keys():
	with open("clone_%s_germline.fa"%(CLONE),'w') as File:
		
		#save germline as first seq_record
		if SUMMARY[CLONE][index_GENE_multi] == 'False':
			GENE = SUMMARY[CLONE][index_GENE]
			
		else:
			CALLS = GENE = SUMMARY[CLONE][index_CALL].split(',')
			if len( CALLS ) > 1:
				sys.stderr.write("WARNING: Probable error, several call concerning clone %s (calls: %s)\n"%(CLONE,','.join(CALLS)))
				continue 
			else:
				sys.stderr.write("WARNING: keep only first match, because several gene concerning clone %s\n"%(CLONE))
				GENE = SUMMARY[CLONE][index_GENE].split(',')[0]
				
		File.write(">G.L._%s\n%s\n"%(GENE, insert_in_string( GERMLINE[GENE] ) ))

		#save each clone member
		for TabLine in TABFILE:
			if TabLine[index_CLONE] == CLONE:
				File.write(">%s\n%s\n"%(TabLine[index_SeqID], insert_in_string(TabLine[index_CDR3]) ))
			
