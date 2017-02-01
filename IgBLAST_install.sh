#!/bin/bash
set -e
# Install # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
if [ ]; then echo "install IgBlast"
	
	cd ~
	
	wget -nv -nc ftp://ftp.ncbi.nih.gov/blast/executables/igblast/release/1.6.1/ncbi-igblast-1.6.1-x64-linux.tar.gz
	wget -nv -nc ftp://ftp.ncbi.nih.gov/blast/executables/igblast/release/1.6.1/ncbi-igblast-1.6.1-x64-linux.tar.gz.md5
	md5sum -c ncbi-igblast-1.6.1-x64-linux.tar.gz.md5
	
	tar -xf ncbi-igblast-1.6.1-x64-linux.tar.gz
	rm ncbi-igblast-1.6.1-x64-linux.tar.gz ncbi-igblast-1.6.1-x64-linux.tar.gz.md5
	mv ncbi-igblast-1.6.1 ncbi-igblast

	cd ncbi-igblast
	#internal data
	wget -nv --mirror ftp://ftp.ncbi.nih.gov/blast/executables/igblast/release/internal_data
	mv ftp.ncbi.nih.gov/blast/executables/igblast/release/internal_data bin/ && rm -r ftp.ncbi.nih.gov
	
	#script to change fasta name lol
	wget -nv -nc ftp://ftp.ncbi.nih.gov/blast/executables/igblast/release/edit_imgt_file.pl
	
	#Optional files
	wget -nv --mirror ftp://ftp.ncbi.nih.gov/blast/executables/igblast/release/optional_file
	mv ftp.ncbi.nih.gov/blast/executables/igblast/release/optional_file bin/ && rm -r ftp.ncbi.nih.gov
fi

bash IMGT_local.sh

IGBLAST=~/ncbi-igblast/bin
IGBLASTDBPATH=~/ncbi-igblast/IMGT_DB/

if [ 0 ];then echo "make igblast database"
	
	# download manually the fasta information AND GIVE .fasta name (otherwise MakeDb.py crashes)
	#http://imgt.org/vquest/refseqh.html
	#http://imgt.org/genedb/GENElect?query=7.14+IGHV&species=Mus
	#http://imgt.org/genedb/GENElect?query=7.14+IGHD&species=Mus
	#http://imgt.org/genedb/GENElect?query=7.14+IGHJ&species=Mus
	
	for FILE in $(ls $IGBLASTDBPATH/*.fasta );do
		filename="${FILE%.*}"
		perl ~/ncbi-igblast/edit_imgt_file.pl $FILE > $filename
		makeblastdb -parse_seqids -dbtype nucl -in $filename
	done


fi
