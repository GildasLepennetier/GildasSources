#!/bin/bash

################################################################################
#
#	Install tools for a functional Linux environment
#
#	apt: Advanced Package Tool
#
#	Copyright 2015 LEPENNETIER Gildas
#	Author: Gildas Lepennetier - gildas.lepennetier@hotmail.fr
#
#																2 July 2015
################################################################################

################################################################################
#
#			options
#
set -e						# to stop this script if error
workDir=$(pwd)				# current working directory
yes="--assume-yes"			# to say yes during install
wgetOpt="-nc -c"			# option for the wget
processorType=$(arch)		# processor type: i386, amd64...
archi=$(getconf LONG_BIT)	# computer's architechture: return 32 or 64
OS=$(uname -s)
L=""						# list of programs to install
################################################################################

# OTHER packages mannagers
#sudo apt-get install rpm	#package manager
#sudo apt-get install yum	#yum updater


if [ 0 ];then echo -e "\n added: system (compiler and compatibility)"
	#L="$L htop"	#display system daemons
	L="$L g++"	#C compiler
	L="$L wine"	#wine windows compatibility
fi

# python packages
if [ 0 ];then echo -e "\n added: python extra tools"
	L="$L python-dev python-setuptools"	#python setup tools: easy_install
	L="$L python-numpy python-scipy python-matplotlib ipython ipython-notebook python-pandas python-sympy python-nose"	# scipy and numpy
	L="$L python-biopython python-biopython-doc python-biopython-sql"	# biopython
	L="$L idle idle3" # IDLE for python3
	#L="$L python-pip"	# pip for cutadapt
fi

# SSH
if [ 0 ];then echo -e "\n added: ssh and sshd"
	L="$L openssh-server"
fi

#internet tools
if [ 0 ];then echo -e "\n added: internet tools"
	L="$L curl"	#internet function: download pages
	L="$L whois"	#link ip and domain
	L="$L nmap"	#Network Mapper
	#L="$L apache2-bin" # Apache system ???
fi

#bioinfo
if [ 0 ];then echo -e "\n added: (bio)informatic tools"
	L="$L libncurses-dev"			# required by tuxedo ?
	L="$L tophat bowtie cufflinks"	# tuxedo programs
	L="$L bedtools"					# bam to fastq
	# blast
	L="$L ncbi-blast+"
fi

# Thunderbird mail agent
if [ 0 ];then echo -e "\n added: Thunderbird"
	L="$L thunderbird"
fi

# Filezilla FTP agent
if [ 0 ];then echo -e "\n added: Filezilla"
	L="$L filezilla"
fi

#
echo "$L"
echo "install those packages? (yes)"
read q
if [ "$q" == "yes" ]; then sudo apt-get install $L $yes; else echo "Cancelled"; fi

# fix dependencies problems
sudo apt-get install -f
#sudo apt-get build-dep "package" $yes #specifically build dependencies for the package


# RepeatMasker
if [ ];then cd $HOME; echo -e "\n G install: RepeatMasker, libraries and search programs"
	
	echo "careful, this is not finished - enter to continue"
	echo "todo: repeatmasker in a better place than home, same for hmmer and so one"
	read X
	
	if [ ! -d trf ];then echo "get tandem repeat finder - trf"
		mkdir -p "$HOME/trf"
		echo "Download the program by clicking on the button, then put it in the directory called 'trf' in your home"
		echo "go to : http://tandem.bu.edu/trf/trf407b.linux.download.html"
		echo "when done, press here enter. trf address should be: $HOME/trf"
		read X
		mv -v $HOME/trf/trf407b.linux $HOME/trf/trf
		sudo chmod +x $HOME/trf/trf
	fi
	
	if [ ! -d RepeatMasker ];then echo "get RepeatMasker"
		wget -nc -c http://www.repeatmasker.org/RepeatMasker-open-4-0-5.tar.gz
		tar -xf RepeatMasker-open-4-0-5.tar.gz
		rm RepeatMasker-open-4-0-5.tar.gz
	fi
	

	if [ 0 ];then echo "install Hmmer"
		wget -nc -c http://selab.janelia.org/software/hmmer3/3.1b1/hmmer-3.1b1-linux-intel-ia32.tar.gz
		tar -xf hmmer-3.1b1-linux-intel-ia32.tar.gz
		cd hmmer-3.1b1-linux-intel-ia32
		
		./configure
		make #build
		make check #automated tests
		sudo make install #automated install
		cd $HOME
		rm hmmer-3.1b1-linux-intel-ia32.tar.gz
		rm -r hmmer-3.1b1-linux-intel-ia32
	fi
	
	if [ 0 ];then echo "search program RMVlast / Blast"
	
		echo "downloading RMBlast Binaries"
		
		wget -nc -c ftp://ftp.ncbi.nlm.nih.gov/blast/executables/rmblast/LATEST/ncbi-rmblastn-2.2.28-ia32-linux.tar.gz
		tar zxvf ncbi-rmblastn-2.2.28-ia32-linux.tar.gz
		rm ncbi-rmblastn-2.2.28-ia32-linux.tar.gz

		echo "downloading BLAST+ Binaries"
		
		wget -nc -c ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.2.30+-ia32-linux.tar.gz
		tar zxvf ncbi-blast-2.2.30+-ia32-linux.tar.gz
		rm ncbi-blast-2.2.30+-ia32-linux.tar.gz
		
		cd $HOME/ncbi-blast-2.2.30+/bin/
		sudo chmod +x *
		cp -v $HOME/ncbi-rmblastn-2.2.28/bin/rmblastn .
				
		echo "move everything in usr/local/bin"
		cp $HOME/ncbi-blast-2.2.30+/bin/* usr/local/bin
		
		read X
	fi
	
	if [ 0 ];then echo "downloading Libraries - if error -> check versions"
		cd RepeatMasker
		#repbase require login
		#echo "You should register to access the RepBase libraries. it is not allowed to use gildas's password, legally";exit
		LOGIN=gildas
		PASS=edr6qv
		VERSION=20.04
		wget -nc -c --user=$LOGIN --password=$PASS http://www.girinst.org/server/RepBase/protected/RepBase$VERSION.embl.tar.gz
		tar -xvf RepBase$VERSION.embl.tar.gz
		wget -nc -c --user=$LOGIN --password=$PASS http://www.girinst.org/server/RepBase/protected/repeatmaskerlibraries/repeatmaskerlibraries-20140131.tar.gz
		tar -xvf repeatmaskerlibraries-20140131.tar.gz
		wget -nc -c --user=$LOGIN --password=$PASS http://www.girinst.org/server/RepBase/protected/REPET/RepBase19.06_REPET.embl.tar.gz
		tar -xvf RepBase19.06_REPET.embl.tar.gz
		wget -nc -c --user=$LOGIN --password=$PASS http://www.girinst.org/server/RepBase/openaccess/dfamrepref.embl.tgz
		gzip -dvk dfamrepref.embl.tgz
		### duplicate with embl
		### wget -nc -c --user=$LOGIN --password=$PASS http://www.girinst.org/server/RepBase/protected/RepBase19.12.fasta.tar.gz
		### tar -xvf RepBase19.12.fasta.tar.gz
	fi
	
	echo "configure RepeatMasker"
	
	#sudo find / -name nhmmer
	echo "hammer: /usr/local/bin"
	echo "rmbalst: $HOME/ncbi-blast-2.2.30+/bin"
	
	read X
	cd $HOME/RepeatMasker/
	perl configure
	
	#RepeatMasker version open-4.0.5
	#WARNING: The first version of Dfam is a human database. Searching
	#with other species will only search for ancestral repeats shared
	#with human and your species ( if any exist ).
	#Search Engine: HMMER [ 3.1b1 (May 2013) ]
	#Master RepeatMasker Database: /home/caine/RepeatMasker/Libraries/Dfam.hmm ( Complete Database: Dfam_1.2 )
	#Building general libraries in: /home/caine/RepeatMasker/Libraries/Dfam_1.2/general
	#Building species libraries in: /home/caine/RepeatMasker/Libraries/Dfam_1.2/drosophila_fruit_fly_genus
	#- 70 ancestral and ubiquitous sequence(s) for drosophila fruit fly genus
	#- 0 lineage specific sequence(s) for drosophila fruit fly genus
fi

# R
if [ ];then cd $HOME; echo -e "\n G install: R and RStudio"
	
	#dependencies required
	sudo apt-get install libjpeg62 $Y 
	
	# R
	sudo apt-get install r-base r-base-dev r-base-html r-doc-html $Y  #libjpeg62 required
	
	# RStudio
	VERSION=0.99.441
	if [ "$ARCH" == "i386" ];then V=$VERSION-i386; fi
	if [ "$ARCH" == "i686" ];then V=$VERSION-i386; fi #http://download1.rstudio.org/rstudio-0.99.441-i386.deb
	if [ "$ARCH" == "x86_64" ];then V=$VERSION-amd64; fi #http://download1.rstudio.org/rstudio-0.99.441-amd64.deb
	
	wget -nc -c http://download1.rstudio.org/rstudio-$V.deb
	
	sudo dpkg -i rstudio-$V.deb
	rm rstudio-$V.deb
	
	#java compiler ? r-java
	#sudo apt-get install gcj-aarch64-linux-gnu r-cran-rjava
	
	#exporting variable
	#R CMD javareconf -e
	
	if [ ];then 
		echo "run sudo R"
		
		#for Bioconductor
# 		source("http://bioconductor.org/biocLite.R")
# 		biocLite("BiocUpgrade")
# 			#biocValid()
# 			#biocLite()
# 		biocLite("cummeRbund") #Sequencing
# 			#biocLite("ArrayExpressHTS")
# 		biocLite("QuasR")
# 			#biocLite("rjava")
# 		biocLite("limma") #for Venn Diagram
# 		
# 		#PACKAGES default lib=/home/gildas/R/x86_64-pc-linux-gnu-library/3.1
# 		install.packages("ggplot2",dependencies=T,repos="http://mirrors.softliste.de/cran/")			#plot
# 		install.packages("zoo",dependencies=T,repos="http://mirrors.softliste.de/cran/")				#rolling function
# 		install.packages("plyr",dependencies=T,repos="http://mirrors.softliste.de/cran/")	        	#arrange dataframe
# 		install.packages("gtools",dependencies=T,repos="http://mirrors.softliste.de/cran/")	        	#cut a vector depending on quantiles
# 		install.packages("ppcor",dependencies=T,repos="http://mirrors.softliste.de/cran/")	        	#partial corelation
# 		install.packages("FactoMineR",dependencies=T,repos="http://mirrors.softliste.de/cran/")			#PCA
# 		install.packages("ade4",dependencies=T,repos="http://mirrors.softliste.de/cran/")	        	#PCA
# 		install.packages("rgl",dependencies=T,repos="http://mirrors.softliste.de/cran/")				#repository=Berlin #plot3d, X11 and header GL/gl.h required
# 		install.packages("argparse",dependencies=T,repos="http://mirrors.softliste.de/cran/")			#argument parser
# 		install.packages("vegan",dependencies=T,repos="http://mirrors.softliste.de/cran/")				#with Karsten
# 		install.packages("rococo",dependencies=T,repos="http://mirrors.softliste.de/cran/")				#Robust Rank Correlation Coefficient test
# 		install.packages("boot",dependencies=T,repos="http://mirrors.softliste.de/cran/")				# bootstrap
# 		install.packages("raster",dependencies=T,repos="http://mirrors.softliste.de/cran/")				# modal value, ...
# 		install.packages("VennDiagram",dependencies=T,repos="http://mirrors.softliste.de/cran/")				# Venn Diagram
# 		
	fi

fi

# imageMagick - tiff support
# imageMagick - cmd line
if [ ];then cd $HOME; echo -e "\n G install: imageMagick"
	
	if [ ];then echo -e "\n tiff support - need to be installed first"
		
		rm -fr tiff-4.0.3 #because we want clean
		
		wget -nc -c "ftp://ftp.remotesensing.org/libtiff/tiff-4.0.3.tar.gz"
		tar xzf "tiff-4.0.3.tar.gz"
		rm -v "tiff-4.0.3.tar.gz"
		cd "tiff-4.0.3"
		
		echo "patching the stuff..."
		wget -nc -c "http://www.linuxfromscratch.org/patches/blfs/svn/tiff-4.0.3-fixes-1.patch"
		patch -Np1 -i tiff-4.0.3-fixes-1.patch
		
		rm tiff-4.0.3-fixes-1.patch
		
		./configure
		make clean
		make
		make check
		sudo make install
		
		cd $HOME
		rm -r tiff-4.0.3
	fi
	
	sudo apt-get install imagemagick $Y 
	sudo ldconfig /usr/local/lib #to fix shared library problems
	
	#check some variables
	#convert -list configure
	#convert -list format
	
	if [ ];then echo "manual (hope it works, if the previous option do not)"
		cd $HOME
		VERSION_MAGICK="6.9.1-3"
		wget -nc -c "ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick-$VERSION_MAGICK.tar.gz"
		
		#ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick.tar.gz
		
		tar xzf "ImageMagick-$VERSION_MAGICK.tar.gz"
		rm -v "ImageMagick-$VERSION_MAGICK.tar.gz"
		cd "ImageMagick-$VERSION_MAGICK"
		./configure
		make check
		sudo make install
		sudo ldconfig /usr/local/lib #to fix shared library problems
		make clean
		
		#http://www.imagemagick.org/script/command-line-tools.php
		#http://www.imagemagick.org/Usage/
	fi
	
fi


# Zotero
if [ ];then cd $HOME; echo -e "\n G install: zotero"
	## to run directly from bash, you should add the address to the PATH, OR a file called zotero that run it (ex: #!/bin/bash\nbash PathToZotero)
	if [ "$ARCH" == "i386" ];then VERSION=i386; fi
	if [ "$ARCH" == "i686" ];then VERSION=i386; fi
	if [ "$ARCH" == "x86_64" ];then VERSION=x86_64;	fi
	wget -nc -c https://download.zotero.org/standalone/4.0.19/Zotero-4.0.19_linux-$VERSION.tar.bz2
	tar -xjf Zotero-4.0.19_linux-$VERSION.tar.bz2
	cd Zotero_linux-$VERSION/
	./run-zotero.sh
	echo "id: gildas.lepennetier@hotmail.fr"
	cd ..
	rm Zotero-4.0.19_linux-$VERSION.tar.bz2
	
	#preferences: user: gildas.lepennetier@hotmail.fr (sy)
fi

# Dropbox
if [ ];then cd $HOME; echo -e "\n G install: Dropbox"
	sudo apt-get install nemo python-gpgme libnemo-extension1 nemo-dropbox $Y 
	echo "TODO: nemo --quit #need to quit the daemon"
	echo "TODO dropbox start -i"
	#gilou_on_net@hotmail.com
	#sy...
fi

# PERL
if [ ];then cd $HOME; echo -e "\n G install: perl modules"
	sudo apt-get install perl-doc $Y 
	#search modules -> http://search.cpan.org/
	# perl modules
	sudo cpan install Base
	sudo cpan HTTP
	echo "TODO: install CPAN"
	echo "TODO: reload cpan"
fi

################################################################################

## FIREFOX sync: gildas.lepennetier@hotmail.fr

# cmd to know - MEMO
if [ ];then cd $HOME; echo -e "\n G install: commands to know / master"
	### commands to know
	sudo apt-get install -f	# fix brocken packages
	sudo apt-get update		# update
	sudo apt-get upgrade $Y	# upgrade
	sudo apt-get autoremove	# remove

	hostname NewName		# change computer name
	lscpu				# cpu infos

	echo uname #unix name
	echo arch #achitecture
	echo rsync #synchronization
	echo fdisk #checkdisk

	echo which #where is the command located
	echo du #disl use
	echo df #disk free
	echo dd #copy data
	echo find #do not forget the -name option
	echo locate #using index to search

	echo !! #!! is replaced by the previous command / potential error of execution: echo $(!!)
	echo useradd and adduser

	#gestion of the volume sound
	echo alsamixer
	
	echo ping 128.176.213.35 -c 5 #ping my office
fi
# tips, techniques and so on
if [ ];then cd $HOME; echo -e "\n G install: little notes"
	exit
	############################################################################
	######## mount a disk
	# UUID="10E82EB2E82E964E"
	# type="ntfs"
	# dir="/media/Daten"
	# sudo mkdir -p $dir
	# sudo mount -t $type -U $UUID $dir
	######## make it auto
	#sudo nano /etc/fstab # mount automatically Daten ( DIRECTORY must exist)
	#UUID=10E82EB2E82E964E /media/Daten ntfs defaults 0 2
	############################################################################
	######## which user are you ?
	if [[ ${EUID} == 0 ]] ; then echo "you are root";else echo "you are not root, but user: $EUID"; fi
	[ ${EUID} == 0 ] && echo "you are root" || echo "you are not root, but user: $EUID"
	############################################################################
	######## colors in terminal
	#https://wiki.archlinux.org/index.php/Color_Bash_Prompt#Basic_prompts
	# in nano /etc/bash.bashrc
	# echo $PS1 #colors for terminal
	#PS1="\[\033[0;31m\]$(returncode)\[\033[0;37m\]\[\033[0;35m\]${debian_chroot:+($debian_chroot)}\[\033[0;35m\]\u@\h\[\033[0;37m\]:\[\033[0;36m\]\w >\[\033[0;00m\]"
	# put everything in blue
	#PS1="\[\033[34m\][\$(date +%H%M)][\u@\h:\w]$ "
	############################################################################
	############################################################################
	# PBS (portable batch system) :http://dcwww.camd.dtu.dk/pbs.html
	#How to:
	#command for submission is
	qsub subfile
	############################################################################
	#subfile:
	#!/bin/sh
	### Job name
	#PBS -N test
	### Declare job non-rerunable
	#PBS -r n
	### Output files
	#PBS -e test.err
	#PBS -o test.log
	### Mail to user
	#PBS -m ae
	### Queue name (small, medium, long, verylong)
	#PBS -q long
	### Number of nodes (node property ev67 wanted)
	#PBS -l nodes=8:ev67
	# This job's working directory
	echo Working directory is $PBS_O_WORKDIR
	cd $PBS_O_WORKDIR
	echo Running on host `hostname`
	echo Time is `date`
	echo Directory is `pwd`
	echo This jobs runs on the following processors:
	echo `cat $PBS_NODEFILE`
	# Define number of processors
	NPROCS=`wc -l < $PBS_NODEFILE`
	echo This job has allocated $NPROCS nodes
	# Run the parallel MPI executable "a.out"
	mpirun -v -machinefile $PBS_NODEFILE -np $NPROCS a.out
	############################################################################
fi

#
# non-necessary / memo
#
# libreoffice - manual installation
if [ ];then cd $HOME; echo -e "\n G install: libreoffice"
	#install kde integration for libreoffice
	sudo apt-get install libreoffice-kde
	#download libreoffice - last version
	read -p "Did you update the version in the script?"
	wget -nc -c http://donate.libreoffice.org/fr/dl/deb-x86_64/4.3.7/fr/LibreOffice_4.3.7_Linux_x86-64_deb.tar.gz
	tar -xvzf LibreOffice_4.3.7_Linux_x86-64_deb.tar.gz
	cd LibreOffice_4.3.7.2_Linux_x86-64_deb/DEBS
	sudo dpkg -i *.deb
	cd ../..
	rm -r LibreOffice_4.3.7.2_Linux_x86-64_deb
	rm LibreOffice_4.3.7_Linux_x86-64_deb.tar.gz
fi

#sudo apt-get install gnumeric	#excel 

# git
if [ ];then cd $HOME; echo -e "\n G install: Git - supposed to be there already"
	sudo apt-get install git $Y
	
	#exemple: clone the pirate bay
	#git clone https://github.com/isohuntto/openbay.git
	#git clone https://github.com/GildasLepennetier/GildasSources.git
	#git clone https://github.com/GildasLepennetier/smartPySpider.git
fi

#SSH: to know
if [ ];then
	#############################
	## ssh : programme client permetant de se connecter au serveur
	## sshd : daemon écoutant sur un port (default=22)
	#sudo service ssh start
	#sudo service ssh stop
	#sudo service ssh restart
	#service ssh status
	
	echo "internet protocol address: "
	ifconfig | grep "inet addr:"
	
	## log file: 
	grep ssh /var/log/auth.log
	
	## config: 
	cat /etc/ssh/sshd_config #exemple: Port 1 to 65535; PermitRootLogin no
	## sudo to modify
	sudo nano /etc/ssh/sshd_config
	
	
	## Test connection
	#ssh gildas@localhost #to self
	#ssh glepe_01@palma1.uni-muenster.de # Connection to PALMA ( 128.176.188.146 )
	#ssh glepe_01@zivsmp.uni-muenster.de
	#ssh glepe_01@vpnserver.uni-muenster.de # Connection to the ZIV, gateway
	#ssh -p 55555 glepe_01@ebbgateway.uni-muenster.de #then ssh ebbsrv02
	#ssh  caine@92.228.253.168
	#other ip for home: 92.231.13.161
	#*********
	#PBS -o /scratch/tmp/glepe_01/COMPUTED/output.dat
	#PBS -l walltime=02:00:00,nodes=4:westmere:ppn=12
	#PBS -A r0catani
	#PBS -M glepe_01@uni-muenster.de
	#PBS -m e
	#PBS -q default
	#PBS -N Job_001
	#PBS -j oe
	#cd path/to/script and files
	#python file arg1 arg2
	#*********
	#qsub submit.cmd
	# qstat : Affiche la file d'attente actuelle - Zeigt die derzeitige Warteschlange an
	# qstat -a : Pareil, seulement avec le nombre de nœuds demandés - Selbiges, nur mit Anzahl der angeforderten Knoten
	# qstat -n : Tous les nœuds sont affectés aux emplois sont brisés - Alle Knoten, die den Jobs zugeordnet sind, werden aufgeschlüsselt
	# qdel Jobnummer : Supprime les travaux de la file d'attente - Löscht Jobs aus der Warteschlange
	# showbf : Affiche le nombre de cœurs de processeur disponibles - Zeigt die Anzahl der freien Prozessorkerne
	# showres : Indique quand un travail est lancé - Zeigt an, wann ein Job gestartet wird
	#*********
	#### regeneration des keys: in ~ /.ssh/id_rsa
	#ssh-keygen
	#Your identification has been saved in /home/gildas/.ssh/id_rsa.
	#Your public key has been saved in /home/gildas/.ssh/id_rsa.pub.
	#ssh-copy-id log@server
fi

if [ ];then
	sudo easy_install weblogo			# weblogo
	sudo easy_install --upgrade weblogo
	sudo pip install cutadapt			# cutadapt
	
	# blat for x86_64
	wget -nc -c http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/blat/blat
	sudo chmod +x blat
	sudo mv blat /usr/bin/blat
	
	
	#sudo apt-get install pinta $Y #paint-like
	#sudo apt-get install freemind $Y 
	
	#midnight commander
	#sudo apt-get install mc $Y
	
	#L="$L dmidecode"	#view BIOS Information
	#L="$L baobab"	#disc usage
fi