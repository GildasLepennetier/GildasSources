#!/usr/bin/env python


import sys,re

class BlastMatch:
	Query=str
	QueryLength=int
	Subject=str
	SubjectLength=int
	Score=str
	Expect=str
	Identities=str
	Gaps=str
	Strand=str
	Aligment=[]
	
	def show(self):
		print('\n')
		print("QueryLength %s"%self.QueryLength)
		print("SubjectLength %s"%self.SubjectLength)
		print("Score %s"%self.Score)
		print("Expect %s"%self.Expect)
		print("Identities %s"%self.Identities)
		print("Gaps %s"%self.Gaps)
		print("Strand %s"%self.Strand)
		print("Query %s"%self.Query)
		print("Subject %s"%self.Subject)
		for line in self.Aligment:
			print(line)


def blastParser_getMatchLineNb(lines):
	lineCounter=0
	for rline in lines:
		if re.search(' Score', rline):
			yield lineCounter
		lineCounter+=1


def blastParser(file):
	LINES=[e.split('\n')[0] for e in file.readlines()]
	
	if LINES[0].startswith("BLAST"):
		BLAST_PROG=LINES[0].split(' ')[0]
		BLAST_VERSION=LINES[0].split(' ')[1]
		
		#sys.stderr.write("Detected: %s version %s\n"%(BLAST_PROG,BLAST_VERSION))
		if int(BLAST_VERSION.split('.')[0]) < 2:
			sys.stderr.write("WARNING: blast output version %s may be incompatible!\n"%(BLAST_VERSION))
		
		
	for indexStart in blastParser_getMatchLineNb(LINES):		
		BMatch=BlastMatch()
		### parsing the lines before the ' Score'
		MULTILINES=[]
		Count=0
		for indexBackward in range(indexStart,0,-1):
			if LINES[indexBackward].startswith('Length='):
				
				if Count == 0:
					BMatch.QueryLength=int(LINES[indexBackward].split('=')[1])
					Count+=1
				else:
					BMatch.SubjectLength=int(LINES[indexBackward].split('=')[1])
				
				
								
			if LINES[indexBackward]:
				if LINES[indexBackward].startswith('Query= '):
					MULTILINES.append( LINES[indexBackward].split('Query= ')[1] )
					BMatch.Query=" ".join( reversed( MULTILINES ) )
					MULTILINES=[]
					break
				if LINES[indexBackward].startswith('Subject= '):
					MULTILINES.append(LINES[indexBackward].split('Subject= ')[1])
					BMatch.Subject=" ".join( reversed( MULTILINES ) )
					MULTILINES=[]
					continue
				MULTILINES.append(LINES[indexBackward])
			else: #if empty line, was not splited by blast, then reinitialize
				MULTILINES=[]
		
		for indexForward in range(indexStart,len(LINES),+1):
			CurLine=LINES[indexForward]

			### parsing the lines after the ' Score'
			if CurLine.startswith(' Score'):
				SPLIT=CurLine.split(', ')
				BMatch.Score=SPLIT[0].split(' = ')[1].split(' bits ')[0]
				BMatch.Expect=SPLIT[1].split(' = ')[1]
				continue
			if CurLine.startswith(' Identities'):
				SPLIT=CurLine.split(', ')
				BMatch.Identities=SPLIT[0].split(' = ')[1]
				BMatch.Gaps=SPLIT[1].split(' = ')[1]
				continue
			if CurLine.startswith(' Strand'):
				BMatch.Strand=CurLine.split('=')[1]
				continue
			#get alignment until Lambda is reached
			if CurLine:
				if CurLine.startswith('Lambda'):
					yield BMatch
					break
				else:
					BMatch.Aligment= BMatch.Aligment + [CurLine]



if __name__ == "__main__":
	import argparse
	parser = argparse.ArgumentParser(description="Parser for blast output",epilog='Author: Gildas Lepennetier')
	parser.add_argument('files', nargs=argparse.REMAINDER)
	parser.add_argument('-out', type=argparse.FileType('w'),default=sys.stdout, help='output file name, otherwise print in stdout')
	parser.add_argument('-in', type=argparse.FileType('r'),default=sys.stdin, help='intput file name, otherwise take from stdin')
	parser.add_argument('--copy',action='store_true',help='Display Copyright informations')
	parser.add_argument('--author',action='store_true',help='Display author informations')
	parser.add_argument('--verbose', '-v', action='count',default=0,help='add flag(s) to increase verbosity')# count the level of verbosity, +1 for each -v flag
	parser.add_argument('--quiet',action='store_true',help='to remove the error messages')

	args=vars(parser.parse_args())

	if args['author']:
		print ("LEPENNETIER Gildas - gildas.lepennetier@hotmail.fr")
		exit()
	if args['copy']:
		print ("Copyright 2016 LEPENNETIER Gildas")
		exit()


	if len(args['files']) > 0:
		for F in args['files']:
			for e in blastParser(open(F,'r')):
				e.show()
	else:
		for e in blastParser(args['in']):
			e.show()

