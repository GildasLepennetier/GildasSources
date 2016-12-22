#!/bin/bash

#print summary statistics from the results of the BSR.sh script.
#Gildas Lepennetier 2016

if [ $# -ne 3 ]; then
	echo "usage: script.sh <directory> <read1.gz> <read2.gz>"
	exit 1
fi

DIR=$1
FASTQ1=$2
FASTQ2=$3


cd $DIR

echo "doing: $(basename $DIR)"
R1=$(( $(zcat $FASTQ1 | wc -l) /4 ))
R2=$(( $(zcat $FASTQ2 | wc -l) /4 ))
echo "raw data: $R1 reads1 and $R2 reads2"
ASSEMBL=$(( $(cat assembl_assemble-pass.fastq | wc -l) /4 ))
echo "$ASSEMBL assembled reads"
ASSP=$(( $(cat assembl_quality-pass.fastq | wc -l) /4 ))
ASSF=$(( $(cat assembl_quality-fail.fastq | wc -l) /4 ))
echo "$ASSP good quality of assembled reads"
echo "$ASSF bad quality of assembled reads"
MATCH=$(cat assembl_db-pass.tab | wc -l)
echo "$(($MATCH-1)) good match using IgBlast"


