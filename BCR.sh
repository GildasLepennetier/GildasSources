#!/bin/bash
#
# pRESTO wrapper - working script
# Gildas Lepennetier 2016
#

#set safety options for bash: 
#immediately exit if any command has a non-zero exit status
# set -e
#a reference to any variable you haven't previously defined - with the exceptions of $* and $@ - is an error
set -u
#prevents errors in a pipeline from being masked
set -o pipefail



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
STARTTIME=$(date +%s)
NPROC=15
#read configuration: read 1 = sens (V-region primer) / read 2 = antisens (C-region primer)

READ1_GZ=alml7d_S1_L001_R1_001.fastq.gz
READ2_GZ=alml7d_S1_L001_R2_001.fastq.gz

READ1=read1.fastq
READ2=read2.fastq

CWDir=/home/ga94rac/NextGenSeq/BCR_161207
cd $CWDir

IGBLAST=/home/ga94rac/ncbi-igblast/bin
IGBLASTDBPATH=/home/ga94rac/ncbi-igblast/IgBLAST_DB
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 



##############################################################
# Install igblast and its database
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
if [ ]; then echo "install IgBlast"
	CWD=`pwd`
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
	
	#echo "PATH=\$PATH:`pwd` #ncbi-igblast" >> ~/.bashrc
	
	cd $CWD
fi
if [ ];then echo "make igblast database"
	
	# download manually the fasta information AND GIVE .fasta name (otherwise MakeDb.py crashes)
	#http://imgt.org/vquest/refseqh.html
	#http://imgt.org/genedb/GENElect?query=7.14+IGHV&species=Mus
	#http://imgt.org/genedb/GENElect?query=7.14+IGHD&species=Mus
	#http://imgt.org/genedb/GENElect?query=7.14+IGHJ&species=Mus
	
	perl /home/ga94rac/ncbi-igblast/edit_imgt_file.pl $IGBLASTDBPATH/Mus.IGHD.fasta > $IGBLASTDBPATH/Mus.IGHD
	perl /home/ga94rac/ncbi-igblast/edit_imgt_file.pl $IGBLASTDBPATH/Mus.IGHJ.fasta > $IGBLASTDBPATH/Mus.IGHJ
	perl /home/ga94rac/ncbi-igblast/edit_imgt_file.pl $IGBLASTDBPATH/Mus.IGHV.fasta > $IGBLASTDBPATH/Mus.IGHV
	
	makeblastdb -parse_seqids -dbtype nucl -in $IGBLASTDBPATH/Mus.IGHD
	makeblastdb -parse_seqids -dbtype nucl -in $IGBLASTDBPATH/Mus.IGHJ
	makeblastdb -parse_seqids -dbtype nucl -in $IGBLASTDBPATH/Mus.IGHV
	
	# same for humans BCR
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
##############################################################




##############################################################
# pRESTO 
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
if [ 0 ];then echo "extract FASTQ archive: .gz -> .fastq  careful: NEED to be .fastq for AssemblePairs!"
	zcat $READ1_GZ > $READ1
	zcat $READ2_GZ > $READ2
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
OUTNAME=assembl
if [ 0 ];then echo "pRESTO: AssemblePairs.py align + FilterSeq.py quality"
	# # be sure that read 1 is the good one : the one that is on 5' of the gene, so the V-region (3' is C-region)
	# # 270.3 min
	# # 8 650 650 reads
	
	AssemblePairs.py align -1 $READ1 -2 $READ2 --coord illumina --rc tail --outname $OUTNAME --log AP.log --nproc $NPROC --failed #read2 and 1 are inverted !
	
	rm -v $READ1 $READ2
	
	echo "pRESTO: FilterSeq.py quality Phred quality score >= 20"
	# # 21.2 min
	# # 5,138,768 reads
	FilterSeq.py quality -s "$OUTNAME"_assemble-pass.fastq -q 20 --outname $OUTNAME --log FS.log --nproc $NPROC --failed
	
	cat "$OUTNAME"_quality-pass.fastq | sed -n '1~4s/^@/>/p;2~4p' > "$OUTNAME"_quality-pass.fasta
	
	echo "pRESTO: ParseLog.py AP"
	# 4.4 min
	ParseLog.py -l AP.log -f ID LENGTH OVERLAP ERROR PVALUE # AP_table.tab
	rm -v AP.log
	ParseLog.py -l FS.log -f ID QUALITY # FS_table.tab
	rm -v FS.log

	echo "$OUTNAME"_assemble-pass.fastq
	grep "@" "$OUTNAME"_assemble-pass.fastq | wc -l
	# 10042558
	echo "$OUTNAME"_quality-pass.fastq
	grep "@" "$OUTNAME"_quality-pass.fastq | wc -l
	# 10038139
	echo "$OUTNAME"_quality-pass.fasta
	grep ">" "$OUTNAME"_quality-pass.fasta | wc -l
	# 5136443 ASSEMBLED reads
fi

# collapse # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
LABEL=Seq
if [ 0 ];then echo "collapse identical assembled reads: .nr = non-redondant database"
	# 1) this function does not conserve the fastq format, change the name instead of adding a tag with count, and remove the quality line...
	#fastx_collapser -v -i $READ1 -o read1.nrdb > read1.nrdb.logs
	#fastx_collapser -v -i $READ2 -o read2.nrdb > read2.nrdb.logs
	
	# 2) usearch (faster than blast), but only x32 is free, the x64 cost 1485 USD  http://www.drive5.com/usearch/manual/cmds_all.html
	#usearch -fastx_uniques read1.fq ‑fastqout read1.nrdb.fq -relabel Uniq
	
	# best option, and free
	vsearch --derep_fulllength "$OUTNAME"_quality-pass.fasta --threads $NPROC --relabel $LABEL --relabel_keep --sizeout --output "$OUTNAME"_quality-pass.nr.fasta
	grep ">" "$OUTNAME"_quality-pass.fasta | wc -l
	echo "was reduced to "
	grep ">" "$OUTNAME"_quality-pass.nr.fasta | wc -l
	
# 	Reading file assembl_quality-pass.fasta 100%  
# 	1865999021 nt in 5136443 seqs, min 43, max 494, avg 363
# 	Dereplicating 100%  
# 	Sorting 100%
# 	4004988 unique sequences, avg cluster 1.3, median 1, max 76
# 	Writing output file 100%  
# 	5136443
# 	was reduced to 
# 	4004988
	### inside: sequences are sorted. line is: >Seq1;size=76; here size is the number of duplicated sequences
	### grep "size=1" assembl_quality-pass.nr.fasta | wc -l # 3780596 assembled sequences uniq
fi

# IgBlastn # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
if [ 0 ]; then echo "using the whole file - for pRESTO igblast_out_changeo   ->   -outfmt '7 std qseq sseq btop' "
	# using the whole file (~ 1h)
	#for TRIgS igblast_out_TRIgS   ->   -outfmt '3'
	
	cd $IGBLAST # Neet do change directory to igblastn so it can find easily the internal_data
	
	INFILE=$CWDir/"$OUTNAME"_quality-pass.nr.fasta
	OUTFILE=$CWDir/"$OUTNAME".igb
	echo "input : $INFILE"
	echo "output: $OUTFILE"
	igblastn \
	-num_threads $NPROC \
	-domain_system imgt -ig_seqtype Ig -organism mouse \
	-query $INFILE \
	-out $OUTFILE \
	-auxiliary_data $IGBLAST/optional_file/mouse_gl.aux \
	-germline_db_V $IGBLASTDBPATH/Mus.IGHV \
	-germline_db_J $IGBLASTDBPATH/Mus.IGHJ \
	-germline_db_D $IGBLASTDBPATH/Mus.IGHD \
	-outfmt '7 std qseq sseq btop' \
	-evalue 1.0e-5 #(1.0e-10 to avoid excessive size of file and low quality matches)
	
	cd $CWDir
	
fi

# continue pRESTO # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
if [ 0 ];then echo "post- igblastn processing"
	# using the whole file (~ 1h)
	echo "make database"
	### here: only .fasta for file
	MakeDb.py igblast --regions --scores -i "$OUTNAME".igb -s "$OUTNAME"_quality-pass.nr.fasta -r $IGBLASTDBPATH/Mus.IGHV.fasta $IGBLASTDBPATH/Mus.IGHJ.fasta $IGBLASTDBPATH/Mus.IGHD.fasta
	echo "sort to remove non-functionnal sequences: only F in FUNCTIONAL column. -u = uniquly"
	# IgBlastn
	ParseDb.py select -d "$OUTNAME"_db-pass.tab -f FUNCTIONAL -u T --outname "$OUTNAME"-F
	
	IGBLAST_before=$(wc -l "$OUTNAME"_db-pass.tab | cut -d ' ' -f 1)
	IGBLAST_after=$(wc -l "$OUTNAME"-F_parse-select.tab | cut -d ' ' -f 1)
	echo igblast before $IGBLAST_before after $IGBLAST_after diff is $(($IGBLAST_before-$IGBLAST_after)) that being $( echo "( $IGBLAST_before - $IGBLAST_after ) / $IGBLAST_before * 100" | bc -l ) percent non-functionnal
fi
if [ ]; then echo "find threashold"
	findThreshold_BCR.R "$OUTNAME"-F_parse-select.tab
	exit
	DISTANCE=0.20
	DefineClones.py bygroup -d "$OUTNAME"-F_parse-select.tab --nproc $NPROC --dist $DISTANCE --outname "$OUTNAME"-F
	
	CreateGermlines.py -d "$OUTNAME"-F_clone-pass.tab -r $IGBLASTDBPATH/Mus.IGHV.fasta $IGBLASTDBPATH/Mus.IGHJ.fasta $IGBLASTDBPATH/Mus.IGHD.fasta -g dmask --cloned
fi

# select some groups: 
# > Same V assigment (carefull when several matches)
# > Same J assigment (carefull when several matches)
# > junction of same length
# > clustering acording to CDR3 distance measure

##############################################################
# igtree # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
if [ 0 ];then echo "IgTree / ClustalW"

	if [ 0 ];then echo "prepare summary"
		# get data, clones > 30 members
		echo "make table of count, and germline"
		clones_summary.py "$OUTNAME"-F_clone-pass_germ-pass.tab > clone_table.txt
			
		## select only >= 30 members
		cat clone_table.txt | awk -F "\t" '{ if(NR==1){print $0} if($4+0 >= 30){print $0} }' > clone_table30.txt #use the +0 to convert to integer
	fi
	
	## extract to fasta and add germline, save in a different fasta file
	if [ 0 ];then echo "prepare ClustalW (modify reads record names)"
		
		mkdir -p Clones
		cd Clones
		clones_germline.py ../clone_table30.txt /home/ga94rac/ncbi-igblast/IgBLAST_DB/Mus.IGHV.fasta ../"$OUTNAME"-F_clone-pass_germ-pass.tab
		
		for File in $(ls *.fa); do
			cat $File | sed "s/M04284_13_000000000-ATVWH_//g" > $File.fasta
		done
		
		cd $CWDir
	fi
	
	if [ 0 ];then echo "take each group and align it using clustalw"
	
		#fasta_toolkit -cmd count -in alml7d_all.fa 
		#fasta_toolkit -cmd fa_split -in alml7d_all.fa -vv -rules "MAX_SEQ_PER_FILE=5000"
		# when one alignment takes a lot of time, we can run other in parallel:
		ls Clones/*.fasta | time parallel --eta clustalw -quiet -align -output=pir -infile={}
	fi
		
	
	#clean before : rm *.png *.out.* *.pir.out
	if [ 0 ];then echo "IgTree making the tree"
		
		for File in $(ls Clones/*.pir); do
		
			if [ 0 ]; then
				# we need to find the beginning of the CDR3 
				echo $File
				CDR3_START=$(find_CDR3_alignStart.py $File | cut -f 1)
				echo -e "\tCDR3 start : $CDR3_START"
				CDR3_END=$(find_CDR3_alignStart.py $File | cut -f 2)
				echo -e "\tCDR3 end   : $CDR3_END"
				
				echo -e "\tsize=$(find_CDR3_alignStart.py $File | cut -f 3)"

				echo "running IgTree $(date)"
				/home/ga94rac/TOOLS/IgTree-for-linux.ex1 input=$File start=$CDR3_START end=$CDR3_END dot
				
				echo -e "\tmaking png for .out.sdot and .out.vsdot"
				
				dot -Tpng -O $File.out.sdot
				dot -Tpng -O $File.out.vsdot
			fi
			
			if [ ];then echo "conversion"
				echo "conversion between formats: dot -> graphml"
				## perl function: http://search.cpan.org/~tels/Graph-Easy/bin/graph-easy
				graph-easy --input=$File.out.dot --from dot --output $File.out.graphml --as graphml # ascii, boxart, html, svg, dot|graphviw, txt, vcg, gdl, graphml +some other, see homepage
		
			fi
			# visualise using cytoscape (install apps : apps mannager : network merge , dot-app , JGF app , cyRest , gexf-app )
			
			
			#IgTree input=<input file name> (output=<output file name) 
			#(dot) (mut) (no_reversion)  
			#(0=<start location>) (end=<end location>) 
			#(frame=<frame start) (fr1=<fr1 start>) (fr2=<fr2 start>) (fr3=<fr3 start>) (fr4=<fr4 start>) 
			#(cdr1=<cdr1 start>) (cdr2=<cdr2 start>) (cdr3=<cdr3 start>) (preliminary_trees) (num) (a-to-i) (metadata=<metadata file name>)
		done
	fi
fi
##############################################################

ENDTIME=$(date +%s)
DIFFTIME=$(($ENDTIME - $STARTTIME))
ELAPSED=`date -u -d @${DIFFTIME} +"%T"`
echo "Elapsed: $ELAPSED"

summary_stats_workflow.sh $CWDir $READ1_GZ $READ2_GZ
