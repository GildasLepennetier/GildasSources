#!/bin/bash -e
# 
# Script to include the current directory in he path (Linux), and set execution permissions.
#
# Copyright 2015 LEPENNETIER Gildas
# Author: Gildas Lepennetier - gildas.lepennetier@hotmail.fr

if [ ! -e $HOME/.bashrc ];then
  echo "no bashrc file in the home directory"
  exit 1
fi
if [ $# -lt 1 ];then
  ADD="$(pwd)"
else
	ADD="$1"
fi
#make copy
cp $HOME/.bashrc $HOME/.bashrc_save
#add current path
echo "PATH=\$PATH:$ADD" >> $HOME/.bashrc
echo -e "Done: insertion of\n\t$ADD\nin\n\t$HOME/.bashrc\nA copy of .bashrc was made: .bashr_save"
echo -e "Also:\n\tsudo chmod +x $(pwd)/*"

sudo chmod +x \
BGF\
bind2files\
bindandlist\
countincol\
fasta_toolkit\
firstline\
formatText\
genes_to_introns\
genes_to_introns2\
genes_to_SpliceSite\
genes_to_UTRsize\
genes_updown\
gkill\
GTF_to_genes\
joinsep\
match\
match_in_GFF\
maxentropy\
motif_from_csv\
ntFreq_from_csv\
operation_on_col\
preservedorderincol\
random_selection\
scoring_AS\
seqextractor\
SSS\
to_updown\
trim_seq_in_csv

echo -e "don't forget to reload bash"





