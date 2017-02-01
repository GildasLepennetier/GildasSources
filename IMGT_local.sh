#!/bin/bash

# This script download the html pages available at
# www.imgt.org/vquest/refseqh.html
# and extract the fasta sequences for the genes
# everything is saved in a IMGT folder where the script is executed, in a folder called IMGT_DB
#http://imgt.org/vquest/refseqh.html

STARTTIME=$(date +%s)

mkdir IMGT_DB
cd IMGT_DB

# # # # meaning of "QUERY"
#QUERY=7.2
#"F+ORF+all P": all functional, open reading frame and all pseudogene alleles
#Nucleotides=7.2

#QUERY=7.5 or 7.6
#"F+ORF+in-frame P": all functional, open reading frame, and in-frame pseudogene alleles
#Nucleotides=7.5
#Amino acids =7.6

#QUERY=7.1 or 7.3
#"F+ORF+in-frame P with IMGT gaps": all functional, open reading frame, and in-frame pseudogene alleles for V and C genes. 
#nucleotide=7.1
#Amino acids=7.3


# important: query number
QUERY=7.1

#Note that the IMGT/GENE-DB sets also include the orphons. 

# Save the version and logchange of the data: http://www.imgt.org/IMGTgenedbdoc/programversions.html
#wget -q -nc "http://www.imgt.org/IMGTgenedbdoc/programversions.html" -O programversions.html


# not all species have all types of BCR or TCR
#########################
#species
SPECIES="Homo+sapiens Mus" 
# Immunoglobulines
IG="IGHV IGHD IGHJ" #IGKV IGKJ IGLV IGLJ
# T-cell receptors
TR="TRAV TRAJ TRBV TRBD TRBJ TRGV TRGJ TRDV TRDD TRDJ" 
for gene in $IG $TR; do
	for sp in $SPECIES; do
		echo "doing sp $sp for $gene"
		
		# in two steps, with html for debug:
		#wget -q -nc "http://www.imgt.org/genedb/GENElect?query=$QUERY+$gene&species=$sp" -O $gene.$sp.html
		#cat $gene.$sp.html | awk '{ if(NR > 64){   if( $0 ~ "</pre>"  ){exit;}else{print $0} } }' > $gene.$sp.fasta
		
		
		#example : http://www.imgt.org/genedb/GENElect?query=7.2+IGHV&species=Homo+sapiens
		
		#to directly get the fasta without saving html
		wget -qO- "http://www.imgt.org/genedb/GENElect?query=$QUERY+$gene&species=$sp" | awk '{ if(NR > 64){   if( $0 ~ "</pre>"   ){exit;}else{print $0} } }' > $gene.$sp.fasta
		
		
	done
done
#########################
# for the other species, double check 
#  Rattus+norvegicus Oryctolagus+cuniculus Macaca+mulatta  Oncorhynchus+mykiss Sus+scrofa Danio+rerio Ornithorhynchus+anatinus Vicugna+pacos
#IGHC IGIC IGIJ IGIV IGKC IGLC 
#TRAC TRBC TRGC TRDC



ENDTIME=$(date +%s)
DIFFTIME=$(($ENDTIME - $STARTTIME))
ELAPSED=`date -u -d @${DIFFTIME} +"%T"`
echo "Elapsed: $ELAPSED"







