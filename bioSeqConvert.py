#!/usr/bin/env python
import sys,argparse
from Bio import SeqIO


parser = argparse.ArgumentParser(description="conversion tool for biological sequences (fasta, pir-nbrf)",epilog='Author: Gildas Lepennetier')
parser.add_argument('-stdin', action="store_true",help='give as argument if you wana read from stdin.')
parser.add_argument('-i', help='input file name, otherwise print in stdin')
parser.add_argument('-o', help='output file name, otherwise print in stdout')
parser.add_argument('-cmd', help='command to execut: fasta2pir, pir2fasta...')

parser.add_argument('-pirtype', default="P1",help='type of pir sequence. P1 (default):protein, complet ; F1=protein, fragment')
parser.add_argument('-fasta_line_length', default=70,help='Number of nucleotide per line')

args=vars(parser.parse_args())

def insert_newline(s, each):
	count=0
	new=[]
	for char in s:
		count+=1
		new.append(char)
		if count == each:
			new.append('\n')
			count=0
	return (''.join(new))
		

#check command given
if args['cmd'] not in ['fasta2pir','pir2fasta']:
	sys.stderr.write("Error, unrecognized command\n")
	exit(1)

#Deal with input and output files
if args['stdin']:
	IN=sys.stdin
else:
	if args['i']:
		IN=open(args['i'],'r')
	else:
		sys.stderr.write("Error: input file required with option -i\n")
		exit(1)
		
if args['o']:
	OUT=open(args['o'],'w')
else:
	OUT=sys.stdout


if args['cmd']=="pir2fasta":
	for record in SeqIO.parse(IN, "pir"):
		SeqIO.write(record, OUT, "fasta")


if args['cmd']=="fasta2pir":
	for record in SeqIO.parse(IN, "fasta"):
		ID=record.id
		FEAT=record.description
		SEQ=record.seq
		# > CODE ; SEQID
		# COMMENT
		# SEQUENCE* <-must finish with asterix
		OUT.write(">%s;%s\n%s\n%s*\n"%(args['pirtype'],ID,FEAT,insert_newline( SEQ, each=int(args['fasta_line_length']) ) ) )

if args['o']:
	OUT.close()
if args['i']:
	IN.close()
	