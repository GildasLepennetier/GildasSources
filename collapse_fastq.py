import sys
inname=sys.argv[1]
oname=inname+".clps"
from itertools import groupby
ishead = lambda x: x.startswith('>')
all_seqs = set()
with open(inname) as handle:
	with open(oname, 'w') as outhandle:
		head = None
		for h, lines in groupby(handle, ishead):
			if h:
				head = lines.next()
			else:
				seq = ''.join(lines)
				if seq not in all_seqs:
					all_seqs.add(seq)
					outhandle.write('%s\n%s\n' % (head, seq))