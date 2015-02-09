################################################################################
#
#	script to install tools for a functional Linux environment
#
#
# Copyright 2015 LEPENNETIER Gildas
# Author: Gildas Lepennetier - gildas.lepennetier@hotmail.fr
################################################################################
set -e #to stop if error

	## assume yes for install or not?
YES="--assume-yes"
#YES=""

PWD=$(pwd)

#sudo apt-get install -f # fix brocken packages
#sudo apt-get upgrade
#sudo apt-get update

	## FIREFOX
#gildas.lepennetier@hotmail.fr
#gildas.lepennetier
#recovery key : y-aj2fd-n8fqm-fp4iz-ykz3d-fw9ii

	### libreoffice
if [ ];then
	echo "be careful, check new version"
	read X
	#download libreoffice - last version
	wget -nc http://donate.libreoffice.org/fr/dl/deb-x86_64/4.3.3/fr/LibreOffice_4.3.3_Linux_x86-64_deb.tar.gz
	tar -xvfz LibreOffice_4.3.5_Linux_x86-64_deb.tar.gz
	cd LibreOffice_4.3.5.2_Linux_x86-64_deb/DEBS
	sudo dpkg -i *.deb
	cd ../..
	rm -r LibreOffice_4.3.5.2_Linux_x86-64_deb
	sudo apt-get install libreoffice-kde $YES #install kde integration for libreoffice

fi
	### PDF
#wget -nc ftp://ftp.adobe.com/pub/adobe/reader/unix/9.x/9.5.5/enu/AdbeRdr9.5.5-1_i386linux_enu.deb
#sudo dpkg -i AdbeRdr9.5.5-1_i386linux_enu.deb
#rm AdbeRdr9.5.5-1_i386linux_enu.deb
	



    ### git
if [ ];then
	sudo apt-get install git $YES
	#clone the pirate bay
	#git clone https://github.com/isohuntto/openbay.git
	#git clone https://github.com/GildasLepennetier/GildasSources.git
fi

	### R
if [ ];then
	sudo apt-get install r-base r-base-dev libjpeg62 $YES
	wget -nc http://download1.rstudio.org/rstudio-0.98.507-i386.deb
	sudo dpkg -i rstudio-0.98.507-i386.deb
	rm rstudio-0.98.507-i386.deb
	
	#source("http://bioconductor.org/biocLite.R")
	#biocLite("BiocUpgrade")
fi


	### python
if [ ];then
	#python setup tools: easy_install
	sudo apt-get install python-setuptools $YES
	
	#requirement for biopython : SciPy Stack + python-dev
	#sudo apt-get install python-dev python-numpy python-scipy python-matplotlib ipython ipython-notebook python-pandas python-sympy python-nose $YES
	
	
	#wget -nc http://www.parallelpython.com/downloads/pp/pp-1.6.4.tar.gz
	#tar -xf pp-1.6.4.tar.gz
	#cd pp-1.6.4
	#sudo python setup.py install
	
	## scipy and numpy
	sudo apt-get install python-numpy python-scipy python-matplotlib ipython ipython-notebook python-pandas python-sympy python-nose $YES
	
	## biopython
	sudo apt-get install python-biopython python-biopython-doc python-biopython-sql $YES 

		#sudo easy_install -f http://biopython.org/DIST/ biopython
	## IDLE
	sudo apt-get install idle idle-python2.7 $YES
	
	## weblogo
	sudo easy_install weblogo #sudo easy_install --upgrade weblogo
	
	## pip
	sudo apt-get install python-pip $YES
	
	#sudo pip install cutadapt
fi

	### my SQL
if [ ];then
	sudo apt-get install mysql-server $YES
fi

	### Curl
if [ ];then
	sudo apt-get install curl $YES
fi


	### SSH
if [ ];then
	sudo apt-get install openssh-server $YES
	#############################
	echo "internet protocol address: "
	ifconfig  | grep "inet addr:"
	
	## log file: /var/log/auth.log
	
	## sudo nano /etc/ssh/sshd_config
	
		## ssh	: programme client permetant de se connecter au serveur
		## sshd	: daemon écoutant sur un port (default=22)
		## config: /etc/ssh/sshd_config #exemple: Port  1 to 65535; PermitRootLogin no
	#sudo service ssh start
	#sudo service ssh stop
	#sudo service ssh restart
		
		
		## Test connection
	#ssh gildas@localhost #to self
	#ssh glepe_01@palma1.uni-muenster.de # Connection to PALMA ( 128.176.188.146 )
	#ssh glepe_01@zivsmp.uni-muenster.de
	#ssh glepe_01@vpnserver.uni-muenster.de # Connection to the ZIV, gateway
	#ssh -p 55555 glepe_01@ebbgateway.uni-muenster.de #then ssh ebbsrv02
	#diana@128.176.12.218
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
		# qstat			: Affiche la file d'attente actuelle			- Zeigt die derzeitige Warteschlange an
		# qstat -a		: Pareil, seulement avec le nombre de nœuds demandés	- Selbiges, nur mit Anzahl der angeforderten Knoten
		# qstat -n		: Tous les nœuds sont affectés aux emplois sont brisés	- Alle Knoten, die den Jobs zugeordnet sind, werden aufgeschlüsselt
		# qdel Jobnummer	: Supprime les travaux de la file d'attente		- Löscht Jobs aus der Warteschlange
		# showbf		: Affiche le nombre de cœurs de processeur disponibles	- Zeigt die Anzahl der freien Prozessorkerne
		# showres		: Indique quand un travail est lancé			- Zeigt an, wann ein Job gestartet wird 
	#*********

	#### regeneration des keys: in ~ /.ssh/id_rsa
	#ssh-keygen
		#Your identification has been saved in /home/gildas/.ssh/id_rsa.
		#Your public key has been saved in /home/gildas/.ssh/id_rsa.pub.
		#ssh-copy-id log@server
	#############################
fi


	### Dropbox
if [ ];then
	sudo apt-get install nemo python-gpgme libnemo-extension1 nemo-dropbox $YES
	echo "TODO: nemo --quit #need to quit the daemon"
	echo "TODO dropbox start -i"
fi

	### PERL
if [ ];then
	sudo apt-get install perl-doc $YES
	#search modules -> http://search.cpan.org/
		# perl modules
	sudo cpan install Base
	sudo cpan HTTP
	echo "TODO: install CPAN"
	echo "TODO: reload cpan"
fi

	### Zotero
if [ ];then
	### to run directly from bash, you should add the address to the PATH, OR a file called zotero that run it (ex: #!/bin/bash\nbash PathToZotero)
	wget -nc https://download.zotero.org/standalone/4.0.19/Zotero-4.0.19_linux-x86_64.tar.bz2
	tar -xjf Zotero-4.0.19_linux-x86_64.tar.bz2
	cd Zotero_linux-x86_64/
	./run-zotero.sh
	cd ..
	rm Zotero-4.0.19_linux-x86_64.tar.bz2
	#preferences: user: gildas.lepennetier@hotmail.fr (sy)
fi


	### bioinfo
if [ ];then
	sudo apt-get install libncurses-dev $YES
	sudo apt-get install tophat $YES
	sudo apt-get install bowtie $YES
	sudo apt-get install cufflinks $YES
	echo "please install cummeRbund with R"
	echo "please install samtools"
	echo "please install repeatMasker: script /media/Daten/Tools/repeatMasker/script.sh"
fi

if [ 0 ];then
	echo "go to : http://tandem.bu.edu/trf/trf407b.linux.download.html"
	echo "and download the program, then put it in a directory called 'trp' in your home"
	echo ""
	echo "name it only trf > mv trf407b.linux trf"
	echo "put it the exec rights: > sudo chmod +x trf"
	echo "when done, presse here enter. trf address is: $HOME/trf"
	read X
	
	cd $HOME
	if [ ! -d RepeatMasker ];then
		echo "get RepeatMasker"
		wget -nc http://www.repeatmasker.org/RepeatMasker-open-4-0-5.tar.gz
		tar -xvf RepeatMasker-open-4-0-5.tar.gz
		#rm RepeatMasker-open-4-0-5.tar.gz
	fi
	
	cd $HOME
	if [ ! -d hmmer-3.1b1-linux-intel-ia32 ];then
		echo  "install Hmmer"
		wget -nc http://selab.janelia.org/software/hmmer3/3.1b1/hmmer-3.1b1-linux-intel-ia32.tar.gz
		tar -xvf hmmer-3.1b1-linux-intel-ia32.tar.gz
		cd hmmer-3.1b1-linux-intel-ia32
		./configure
		make #build
		make check #automated tests
		sudo make install #automated install
		cd $HOME
		rm hmmer-3.1b1-linux-intel-ia32.tar.gz
	fi
	
	cd $HOME
	if [ ! -d ncbi-rmblastn-2.2.28 ];then
		echo "downloading RMBlast Binaries"
		wget -nc ftp://ftp.ncbi.nlm.nih.gov/blast/executables/rmblast/LATEST/ncbi-rmblastn-2.2.28-ia32-linux.tar.gz
		tar zxvf ncbi-rmblastn-2.2.28-ia32-linux.tar.gz
		rm ncbi-rmblastn-2.2.28-ia32-linux.tar.gz
		cd ncbi-rmblastn-2.2.28/bin/
		sudo chmod +x rmblastn
	fi

	cd $HOME
	if [ ! -d ncbi-blast-2.2.30+ ];then
		echo "downloading BLAST+ Binaries"
		wget -nc ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.2.30+-ia32-linux.tar.gz
		tar zxvf ncbi-blast-2.2.30+-ia32-linux.tar.gz
		rm ncbi-blast-2.2.30+-ia32-linux.tar.gz
	fi
	
	if [ 0 ];then
		echo "downloading Libraries - if error -> check versions"
		cd RepeatMasker
		#repbase require login
		
		#echo "You should register to access the RepBase libraries";exit
		LOGIN=gildas
		PASS=edr6qv
		
		wget -nc --user=$LOGIN --password=$PASS http://www.girinst.org/server/RepBase/protected/RepBase20.01.embl.tar.gz
		tar -xvf RepBase20.01.embl.tar.gz
		
		wget -nc --user=$LOGIN --password=$PASS http://www.girinst.org/server/RepBase/protected/repeatmaskerlibraries/repeatmaskerlibraries-20140131.tar.gz
		tar -xvf repeatmaskerlibraries-20140131.tar.gz
		
		wget -nc --user=$LOGIN --password=$PASS http://www.girinst.org/server/RepBase/protected/REPET/RepBase19.06_REPET.embl.tar.gz
		tar -xvf RepBase19.06_REPET.embl.tar.gz
		
		wget -nc --user=$LOGIN --password=$PASS http://www.girinst.org/server/RepBase/openaccess/dfamrepref.embl.tgz
		gzip -dvk dfamrepref.embl.tgz
		
		### duplicate with embl
		### wget -nc --user=$LOGIN --password=$PASS http://www.girinst.org/server/RepBase/protected/RepBase19.12.fasta.tar.gz
		### tar -xvf RepBase19.12.fasta.tar.gz
		
	fi
	
	echo "configure RepeatMasker"
	cd $HOME/RepeatMasker/
	perl ./configure
	
	cd $PWD
	#RepeatMasker version open-4.0.5
	#WARNING: The first version of Dfam is a human database.  Searching
	#with other species will only search for ancestral repeats shared
	#with human and your species ( if any exist ).
	#Search Engine: HMMER [ 3.1b1 (May 2013) ]
	#Master RepeatMasker Database: /home/caine/RepeatMasker/Libraries/Dfam.hmm ( Complete Database: Dfam_1.2 )
	#Building general libraries in: /home/caine/RepeatMasker/Libraries/Dfam_1.2/general
	#Building species libraries in: /home/caine/RepeatMasker/Libraries/Dfam_1.2/drosophila_fruit_fly_genus
	#- 70 ancestral and ubiquitous sequence(s) for drosophila fruit fly genus
	#- 0 lineage specific sequence(s) for drosophila fruit fly genus

fi

	### blat
if [ ];then
	# for x86_64
	wget -nc http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/blat/blat 
	sudo chmod +x blat #
fi


	### blast
if [ ];then
	sudo apt-get install ncbi-blast+ $YES
fi


	### LITTLE TOOLS USEFUL
if [ ];then
	sudo apt-get install htop $YES #display system daemons
	sudo apt-get install g++ $YES #C compiler
	sudo apt-get install wine $YES #wine windows compatibility
	sudo apt-get install filezilla $YES #don't forget the import of links
	sudo apt-get install baobab #disc usage
	sudo apt-get install dmidecode #view BIOS Information
	#sudo apt-get install rpm #package mannager
	#sudo apt-get install yum #yum updater
	sudo apt-get install gnumeric $YES
	sudo apt-get install nmap $YES
	sudo apt-get install pinta $YES #paint-like
	sudo apt-get install freemind $YES
	
	sudo apt-get install whois $YES #link ip and domain
fi


	### function very useful to know
if [ ];then
	which uname #unix name
	which arch #achitecture
	which rsync #synchronization
	which fdisk #checkdisk
fi


############################################################################
#
#		tips, tecniques and so on
#
if [ ];then
############################################################################
######## mount a disk
# UUID="10E82EB2E82E964E"
# type="ntfs"
# dir="/media/Daten"
# sudo mkdir -p $dir
# sudo mount -t $type -U $UUID $dir
######## make it auto
#sudo nano /etc/fstab # mount automatically Daten ( DIRECTORY must exist)
#UUID=10E82EB2E82E964E /media/Daten           ntfs    defaults        0       2

############################################################################
######## which user are you ?
if [[ ${EUID} == 0 ]] ; then echo "you are root";else echo "you are not root, but user: $EUID"; fi

############################################################################
######## colors in terminal
	#https://wiki.archlinux.org/index.php/Color_Bash_Prompt#Basic_prompts
# in nano /etc/bash.bashrc
	# echo $PS1	#colors for terminal
#PS1="\[\033[0;31m\]$(returncode)\[\033[0;37m\]\[\033[0;35m\]${debian_chroot:+($debian_chroot)}\[\033[0;35m\]\u@\h\[\033[0;37m\]:\[\033[0;36m\]\w >\[\033[0;00m\]"
	# put everything in blue
#PS1="\[\033[34m\][\$(date +%H%M)][\u@\h:\w]$ "
############################################################################



############################################################################
#			PBS (portable batch system)		:http://dcwww.camd.dtu.dk/pbs.html
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




