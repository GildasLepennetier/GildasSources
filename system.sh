#!/bin/bash
set -e #to stop if error
WD=$(pwd)

SAYYES="--assume-yes"
WGETOPT="-nc -c"

ARCH=$(arch)

################################################################################
#
# Install tools for a functional Linux environment
#
# Copyright 2015 LEPENNETIER Gildas
# Author: Gildas Lepennetier - gildas.lepennetier@hotmail.fr
#
# 19 Mars 2015
################################################################################
### commands to know
#sudo apt-get install -f # fix brocken packages
#sudo apt-get update
#sudo apt-get upgrade

#apt-get autoremove

# git
if [ 0 ];then cd $HOME; echo -e "\n G install: Git - supposed to be there already"
	sudo apt-get install git $SAYYES
	
	#exemple: clone the pirate bay
	#git clone https://github.com/isohuntto/openbay.git
	#git clone https://github.com/GildasLepennetier/GildasSources.git
	#git clone https://github.com/GildasLepennetier/smartPySpider.git
fi
###############################################################################
# python
if [ 0 ];then cd $HOME; echo -e "\n G install: python exra"
	#python setup tools: easy_install
	sudo apt-get install python-dev python-setuptools $SAYYES
	# scipy and numpy
	sudo apt-get install python-numpy python-scipy python-matplotlib ipython ipython-notebook python-pandas python-sympy python-nose $SAYYES
	## biopython
	sudo apt-get install python-biopython python-biopython-doc python-biopython-sql $SAYYES
	## IDLE
	sudo apt-get install idle idle-python2.7 $SAYYES
	## weblogo
	sudo easy_install weblogo $SAYYES
	sudo easy_install --upgrade weblogo
	## pip
	sudo apt-get install python-pip $SAYYES
	#sudo pip install cutadapt
fi

# SSH
if [ 0 ];then cd $HOME; echo -e "\n G install: ssh and sshd"
	
	sudo apt-get install openssh-server $SAYYES
	
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

fi

#bioinfo
if [ 0 ];then cd $HOME; echo -e "\n G install: (bio)informatic tools"
	
	### internet
	sudo apt-get install filezilla $SAYYES #don't forget the import of links
	
	sudo apt-get install curl $SAYYES #internet function: download pages
	sudo apt-get install whois $SAYYES  #link ip and domain
	
	sudo apt-get install apache2-bin $SAYYES  #Apache system for ???
	sudo apt-get install php5-cli $SAYYES  #PHP
	sudo apt-get install mongodb-clients $SAYYES  #MongoDB
	
	### bioinfo
	sudo apt-get install libncurses-dev $SAYYES 
	sudo apt-get install tophat $SAYYES 
	sudo apt-get install bowtie $SAYYES 
	sudo apt-get install cufflinks $SAYYES 
	sudo apt-get install bedtools $SAYYES  #bam to fastq
	
	# blat for x86_64
	wget -nc -c http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/blat/blat
	sudo chmod +x blat
	sudo mv blat /usr/bin/blat
	
	# blast
	sudo apt-get install ncbi-blast+ $SAYYES 
	
	### system
	sudo apt-get install rpm $SAYYES  #package manager
	sudo apt-get install yum $SAYYES  #yum updater
	
	sudo apt-get install htop $SAYYES  #display system daemons
	sudo apt-get install g++ $SAYYES #C compiler
	sudo apt-get install wine $SAYYES  #wine windows compatibility
	#sudo apt-get install chkconfig #manage services not available
	sudo apt-get install dmidecode $SAYYES  #view BIOS Information
	sudo apt-get install baobab $SAYYES  #disc usage
	
	
	
	### other
	sudo apt-get install gnumeric 
	sudo apt-get install nmap 
	sudo apt-get install pinta #paint-like
	sudo apt-get install freemind
	
	
fi

# RepeatMasker
if [ 0 ];then cd $HOME; echo -e "\n G install: RepeatMasker, libraries and search programs"
	
	mkdir -p "$HOME/trf"
	
	if [ ! -d trf ];then echo "get tandem repeat finder - trf"
		echo "Download the program by clicking on the button, then put it in the directory called 'trf' in your home"
		echo "go to : http://tandem.bu.edu/trf/trf407b.linux.download.html"
		echo "when done, press here enter. trf address is: $HOME/trf"
		read X
		mv -v $HOME/trf/trf407b.linux $HOME/trf/trf
		sudo chmod +x $HOME/trf/trf
	fi
	
	if [ ! -d RepeatMasker ];then echo "get RepeatMasker"
		wget -nc -c http://www.repeatmasker.org/RepeatMasker-open-4-0-5.tar.gz
		tar -xvf RepeatMasker-open-4-0-5.tar.gz
		rm RepeatMasker-open-4-0-5.tar.gz
	fi
	

	if [ 0 ];then echo "install Hmmer"
		wget -nc -c http://selab.janelia.org/software/hmmer3/3.1b1/hmmer-3.1b1-linux-intel-ia32.tar.gz
		tar -xvf hmmer-3.1b1-linux-intel-ia32.tar.gz
		cd hmmer-3.1b1-linux-intel-ia32
		bash configure
		make #build
		make check #automated tests
		sudo make install #automated install
		cd $HOME
		rm hmmer-3.1b1-linux-intel-ia32.tar.gz
		rm -r hmmer-3.1b1-linux-intel-ia32
	fi

	
	if [ ];then echo "search program RMVlast / Blast"
	
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
if [ 0 ];then cd $HOME; echo -e "\n G install: R and RStudio"
	
	#dependencies required
	sudo apt-get install libjpeg62 $SAYYES 
	
	# R
	sudo apt-get install r-base r-base-dev r-base-html r-doc-html $SAYYES  #libjpeg62 required
	
	# RStudio
	VERSION=0.99.441-$ARCH
	
	if [ "$ARCH" == "i686" ];then VERSION=0.99.441-i386; fi
	
	wget -nc -c http://download1.rstudio.org/rstudio-$VERSION.deb
				
	sudo dpkg -i rstudio-$VERSION.deb
	rm rstudio-$VERSION.deb
	
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
# imageMagick
if [ 0 ];then cd $HOME; echo -e "\n G install: imageMagick"
	
	sudo apt-get install imagemagick $SAYYES 
	
	if [ ];then echo -e "\n tiff support"
		
		wget -nc -c "ftp://ftp.remotesensing.org/libtiff/tiff-4.0.3.tar.gz"
		tar xzf "tiff-4.0.3.tar.gz"
		rm -v "tiff-4.0.3.tar.gz"
		cd "tiff-4.0.3"
		
		echo "patching the stuff..."
		wget -nc -c "http://www.linuxfromscratch.org/patches/blfs/svn/tiff-4.0.3-fixes-1.patch"
		patch -Np1 -i tiff-4.0.3-fixes-1.patch
		
		rm tiff-4.0.3-fixes-1.patch
		
		bash configure
		make check
		sudo make install
		
		cd $HOME
		rm -r tiff-4.0.3
	fi
	
	if [ ];then echo "manual (hope it works)"
		cd $HOME
		VERSION_MAGICK="6.9.1-2"
		wget -nc -c "ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick-$VERSION_MAGICK.tar.gz"
		tar xzf "ImageMagick-$VERSION_MAGICK.tar.gz"
		rm -v "ImageMagick-$VERSION_MAGICK.tar.gz"
		cd "ImageMagick-$VERSION_MAGICK"
		bash configure
		make check
		sudo make install
		sudo ldconfig /usr/local/lib #to fix shared library problems
		make clean
		
		#http://www.imagemagick.org/script/command-line-tools.php
		#http://www.imagemagick.org/Usage/
	fi
	
fi

############################################################################













################################################################################
################################################################################
################################################################################
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

#back to directory
cd $WD

## FIREFOX sync: gildas.lepennetier@hotmail.fr

# cmd to know
if [ ];then cd $HOME; echo -e "\n G install: commands to know / master"
	
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
	
	echo ping 128.176.213.35 -c 5 #ping...
fi

#
# non-necessary
#

#Filezilla
if [ ];then echo -e "\n G install: Filezilla"
	sudo apt-get install filezilla
fi

#Apach internet :80 httpd
if [ ];then cd $HOME; echo -e "\n G install: build apach server httpd from sources"
	
	#http://httpd.apache.org/docs/2.4/install.html
	exit "not working"
	
	if [ ];then echo "apr required for apache"
		
		mkdir -p $HOME/tmp
		cd $HOME/tmp
		echo "download"
		wget -nc -c http://mirror.dkd.de/apache/apr/apr-1.5.1.tar.gz
		tar -xzf apr-1.5.1.tar.gz
		wget -nc -c http://mirror.dkd.de/apache/apr/apr-util-1.5.4.tar.gz
		tar -xzf apr-util-1.5.4.tar.gz
		
		echo "install - apr"
		cd $HOME/tmp/apr-1.5.1
		bash configure --prefix=$HOME/.srclib/apr
		make
		make test
		sudo make install
	fi
	if [ ];then echo "apr-util required for apache"
		echo "install - apr-util"
		cd $HOME/tmp/apr-util-1.5.4
		bash configure --prefix=$HOME/.srclib/apr-util --with-apr $HOME/.srclib/apr
		make
		make test
		#sudo make install
	fi
		
	if [ ];then echo "download the daemon httpd"
		cd $HOME/.srclib/apr
		bash configure --prefix=$HOME/.srclib/apr
		make
		mkdir -p $HOME/.srclib
	
		#download the httpd daemon
		wget -nc -c http://ftp-stud.hs-esslingen.de/pub/Mirrors/ftp.apache.org/dist/httpd/httpd-2.4.12.tar.gz
		tar -xvzf httpd-2.4.12.tar.gz
		rm httpd-2.4.12.tar.gz
		cd httpd-2.4.12
		bash configure --prefix=$HOME --with-included-apr
		#make
		#make install
		#$HOME/bin/apachectl start
    fi
fi

# PERL
if [ ];then cd $HOME; echo -e "\n G install: perl modules"
	sudo apt-get install perl-doc
	#search modules -> http://search.cpan.org/
	# perl modules
	sudo cpan install Base
	sudo cpan HTTP
	echo "TODO: install CPAN"
	echo "TODO: reload cpan"
fi

# my SQL
if [ ];then cd $HOME; echo -e "\n G install: my SQL"
	sudo apt-get install mysql-server
fi

# Zotero
if [ ];then cd $HOME; echo -e "\n G install: zotero"
	## to run directly from bash, you should add the address to the PATH, OR a file called zotero that run it (ex: #!/bin/bash\nbash PathToZotero)
	wget -nc -c https://download.zotero.org/standalone/4.0.19/Zotero-4.0.19_linux-x86_64.tar.bz2
	tar -xjf Zotero-4.0.19_linux-x86_64.tar.bz2
	cd Zotero_linux-x86_64/
	./run-zotero.sh
	echo "id: gildas.lepennetier@hotmail.fr"
	cd ..
	rm Zotero-4.0.19_linux-x86_64.tar.bz2
	#preferences: user: gildas.lepennetier@hotmail.fr (sy)
fi

# Dropbox
if [ ];then cd $HOME; echo -e "\n G install: Dropbox"
	sudo apt-get install nemo python-gpgme libnemo-extension1 nemo-dropbox
	echo "TODO: nemo --quit #need to quit the daemon"
	echo "TODO dropbox start -i"
	#gilou_on_net@hotmail.com
	#sy...
fi

# PDF
if [ ];then cd $HOME; echo -e "\n G install: Adobe reader"
	read -p "Did you update the version in the script?"
	wget -nc -c ftp://ftp.adobe.com/pub/adobe/reader/unix/9.x/9.5.5/enu/AdbeRdr9.5.5-1_i386linux_enu.deb
	sudo dpkg -i AdbeRdr9.5.5-1_i386linux_enu.deb
	rm AdbeRdr9.5.5-1_i386linux_enu.deb
fi

# libreoffice
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

# FTP
if [ ];then cd $HOME; echo -e "\n G install: FTP Port 21"

	sudo apt-get install vsftpd
	if [ ];then echo "configuration"
		
		#http://computernetworkingnotes.com/network-administration/how-to-configure-ftp-server-in-rhel6.html
		
		service vsftpd status #start restart stop
		
		#firewall
		#iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 21 -j ACCEPT
		
		#main ftp configuration file 
		sudo nano /etc/vsftpd.conf
		sudo nano /etc/vsftpd/user_list
		
		#test:
		ftp 128.176.213.35
		
		anonymous
		
		#commands
		put  To upload files on server
		get  To download files from server
		mput To upload all files
		mget To download all files
		?    To see all available command on ftp prompts
		cd   To change remote directory
		lcd  To change local directory.
		exit To exit
		
		
	fi
fi
