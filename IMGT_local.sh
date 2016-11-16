#!/bin/bash

# This script download the html pages available at
# www.imgt.org/vquest/refseqh.html
# and extract the fasta sequences for the genes
# everything is saved in a IMGT folder where the script is executed


# important: query number
QUERY=7.2


#"F+ORF+all P": all functional, open reading frame and all pseudogene alleles
#Nucleotides=7.2

#"F+ORF+in-frame P": all functional, open reading frame, and in-frame pseudogene alleles
#Nucleotides=7.5
#Amino acids =7.6

#"F+ORF+in-frame P with IMGT gaps": all functional, open reading frame, and in-frame pseudogene alleles for V and C genes. 
#nucleotide=7.1
#Amino acids=7.3

#Note that the IMGT/GENE-DB sets also include the orphons. 

# Immunoglobulines
IG="IGHC  IGHD  IGHJ  IGHV  IGIC  IGIJ  IGIV  IGKC  IGKV  IGLC  IGLJ  IGLV"
# T-cell receptors
TR="TRAV TRA TRAC TRBV TRBD TRBJ TRBC TRGV TRGJ TRGC TRDV TRDD TRDJ TRDC"
#species
SPECIES="Homo+sapiens Mus Rattus+norvegicus Oryctolagus+cuniculus Oncorhynchus+mykiss Macaca+mulatta Sus+scrofa Danio+rerio Ornithorhynchus+anatinus Vicugna+pacos"

STARTTIME=$(date +%s)

mkdir -p IMGT
cd IMGT

# Save the version and logchange of the data: http://www.imgt.org/IMGTgenedbdoc/programversions.html
wget -q -nc "http://www.imgt.org/IMGTgenedbdoc/programversions.html" -O programversions.html

for gene in $IG $TR; do
	mkdir -p $gene
	cd $gene
	
	for sp in $SPECIES; do
		
		echo "doing sp $sp for $gene"
		
		#get html in case of trouble with fasta extraction
		wget -q -nc "http://www.imgt.org/genedb/GENElect?query=$QUERY+$gene&species=$sp" -O $gene.$sp.html
		
		#extract fasta
		cat $gene.$sp.html | sed -n '/^>/{:start /\n$/!{N;b start};/^>.*\n$/p}' > $gene.$sp.fasta
		
		if [ ! -s $gene.$sp.fasta ]; then
			rm $gene.$sp.fasta
		fi
		
		#to directly get the fasta without saving html
		#wget -qO- "http://www.imgt.org/genedb/GENElect?query=$QUERY+$gene&species=$sp" | sed -n '/^>/{:start /\n$/!{N;b start};/^>.*\n$/p}' > $gene.$sp.fasta
	done
	cd ..
done

ENDTIME=$(date +%s)
DIFFTIME=$(($ENDTIME - $STARTTIME))
ELAPSED=`date -u -d @${DIFFTIME} +"%T"`
echo "Elapsed: $ELAPSED"







