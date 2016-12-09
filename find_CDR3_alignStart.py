import sys, re

def load_pir(path):
	Dico={}
	with open(path) as File:
		for rline in File.readlines():
			line=rline.split('\n')[0]
			if line:
				if line[0]=="*": continue
				if line[0]==">":
					ID=line
					continue
			if ID not in Dico.keys():
				Dico[ID]=""
			else:
				Dico[ID]=Dico[ID] + line
	return Dico


DICO = load_pir(sys.argv[1])


#p = re.compile('[-]*')
p = re.compile('[atcgATCG]+[atcgATCG-]*[atcgATCG]+') #[atcgATCG-]*[atcgATCG]+
STARTS=[]
ENDS=[]
for record in DICO:
	if record[:9] == ">DL;G.L.": continue #skip the germline
	#m=p.findall(DICO[record]) #return matches in list
	m=p.search(DICO[record]) #return indexes
	if m:
		STARTS.append(m.start()+1)
		ENDS.append(m.end())

#warning if several possibilities?
if False:
	if len(STARTS) > 1:
		sys.stderr.write("WARNING: several start possibilities: %s"%(",".join([str(e) for e in STARTS])))
	if len(ENDS) > 1:
		sys.stderr.write("WARNING: several end possibilities: %s"%(",".join([str(e) for e in ENDS])))

# print the minimum
if False: 
	Begin=min(STARTS)
	End=min(ENDS)
#print the most common
if True:
	from collections import Counter
	Begin=dict(Counter(STARTS).most_common(1)).keys()[0]
	End=Counter(ENDS).most_common(1)[0][0]

Length=End-Begin+1
print("%s\t%s\t%s"%(Begin,End,Length))



