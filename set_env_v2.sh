#!/bin/bash

################################################################################
#
#	Install tools for a functional Linux environment
#
################################################################################

################################################################################

# required for a lot of code
sudo apt install libboost-all-dev

#####################
# cmd=git			VERSION CONTROL
sudo apt install git
cd ~ ; git clone https://github.com/GildasLepennetier/GildasSources.git
cd ~ ; git clone https://github.com/brentp/bio-playground.git

sudo apt install mercurial


##################### 
# cdm=kalign			ALIGNMENT
cd ~/TOOLS
mkdir Kalign; cd Kalign
wget http://msa.sbc.su.se/downloads/kalign/current.tar.gz
tar -xf current.tar.gz
./configure
make
sudo make install #in /usr/local/bin/
cd ..
rm -r Kalign


# T-coffee
# cmd=t_coffee
cd ~/TOOLS
wget http://www.tcoffee.org/Packages/Stable/Latest/linux/T-COFFEE_installer_Version_11.00.8cbe486_linux_x64.bin
chmod +x T-COFFEE_installer_Version_11.00.8cbe486_linux_x64.bin
./T-COFFEE_installer_Version_11.00.8cbe486_linux_x64.bin
# in /home/ga94rac/t_coffee_bin/Version_11.00.8cbe486/bin
# auto update the .bashrc file, and other things




#### Megan6

#cd ~
#wget -nc http://ab.inf.uni-tuebingen.de/data/software/megan6/download/MEGAN_Community_unix_6_5_10.sh



#####################
# cmd=muscle
sudo apt install muscle #muscle align

#####################
# cmd=belvu			ALIGNMENT VIEWER
# cmd=dotter			COMPARISON of two sequences
# cmd=blixem			BROWSER of pairwise Blast matches
# FROM = http://www.sanger.ac.uk/science/tools/seqtools
cd ~/TOOLS
sudo apt install libcurl4-gnutls-dev libgtk2.0-dev libglib2.0-dev libreadline6-dev libsqlite3-dev 
wget ftp://ftp.sanger.ac.uk/pub/resources/software/seqtools/PRODUCTION/seqtools-4.44.0.tar.gz
tar -xf seqtools-4.44.0.tar.gz
cd seqtools-4.44.0
./configure
make
sudo make install
cd .. 
rm -r seqtools-4.44.0 

##################### TREE
cd ~/TOOLS
wget http://doua.prabi.fr/software/seaview_data/seaview4-64.tgz
tar -xzf seaview4-64.tgz
rm seaview4-64.tgz

#PHYLIP
#https://packages.debian.org/unstable/science/phylip
sudo apt install phylip phylip-doc
#http://evolution.gs.washington.edu/phylip/download/phylip-3.696.tar.gz
cd ~
mkdir phylip ; cd phylip
wget -nc http://evolution.gs.washington.edu/phylip/download/phylip-3.696.tar.gz
tar -xf phylip-3.696.tar.gz
cd phylip-3.696/src
cp Makefile.unx Makefile
make install


#####################
#bioinfo
sudo apt install tophat bowtie ncbi-blast+ bedtools #BIOINFO TOOLS
sudo apt install fastx-toolkit #BIOINFO TOOLS

# QUALITY of multiple sequence alignments
#available online = http://msa.sbc.su.se/cgi-bin/msa.cgi
#http://msa.sbc.su.se/downloads/mumsa-1.0.tgz


sudo apt install linuxbrew-wrapper
sudo apt-get install build-essential
#add /home/ga94rac/.linuxbrew/bin to path
echo -e "\nPATH=/home/ga94rac/.linuxbrew/bin:$PATH #brew\n" >> ~/.bashrc
brew doctor


#####################
# system
sudo apt install kate #text editor
# GKrellM system monitor


# ___required___ for several R libraries
sudo apt install libcurl4-openssl-dev libssl-dev libxml2-dev


#setuptools
wget https://bootstrap.pypa.io/ez_setup.py -O - | sudo python
sudo rm setuptools-26.1.1.zip

sudo apt install python3-setuptools

wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py
python3 get-pip.py

# RPM package installer: use alien
sudo apt install rpm alien


sudo wget -nc http://cancan.cshl.edu/labmembers/gordon/fastq_illumina_filter/release/0.1/fastq_illumina_filter-Linux-x86_64 -P /usr/local/bin
sudo chmod 755 /usr/local/bin/fastq_illumina_filter-Linux-x86_64

#####################
# SRA-toolkit
sudo apt install sra-toolkit

#####################
# bcl2fastq

#dependencies: zlib librt libpthread
sudo apt install zlibc zlib1g-dev
sudo apt install libc6
sudo apt install libpthread-workqueue0 libpthread-workqueue-dev
sudo apt install libboost1.58-all-dev



mkdir /home/ga94rac/NextGenSeq/bcl2fastq/
cd /home/ga94rac/NextGenSeq/bcl2fastq/
### http://support.illumina.com/downloads/bcl2fastq-conversion-software-v217.html
### http://support.web.illumina.com/sequencing/sequencing_software/bcl2fastq-conversion-software/computing-requirements.html
wget ftp://webdata2:webdata2@ussd-ftp.illumina.com/downloads/software/bcl2fastq/bcl2fastq2-v2.17.1.14-Linux-x86_64.zip
unzip bcl2fastq2-v2.17.1.14-Linux-x86_64.zip
sudo alien bcl2fastq2-v2.17.1.14-Linux-x86_64.rpm
sudo dpkg -i bcl2fastq2_0v2.17.1.14-2_amd64.deb

cd ~ ; wget http://www.clustal.org/omega/clustalo-1.2.3-Ubuntu-x86_64 ; cp clustalo-1.2.3-Ubuntu-x86_64 clustalo ; sudo chmod +x clustalo ; sudo mv clustalo /usr/local/bin 



# git clone https://github.com/ShirinG/exprAnalysis.git


sudo apt install perlbrew
perlbrew install-cpanm #auto dependencies

### install BioPerl http://bioperl.org/INSTALL.html
sudo apt install expat

perl -MCPAN -e shell
#to install dependencies automaticly
o conf prerequisites_policy follow
o conf commit
quit

perl -MCPAN -e shell #or just cpan
#answer yes to automatic stuff
#local::lib
#yes to append to .bashrc
# at prompt of CPAN, type:
install Module::Build
o conf prefer_installer MB


d /bioperl/
#install the most recent:
install CJFIELDS/BioPerl-1.6.924.tar.gz

#http://www.ensembl.org/info/docs/api/api_installation.html #?????

#####################
# pRESTO : 
sudo apt-get install python-dev python-numpy python-scipy python-matplotlib ipython ipython-notebook python-pandas python-sympy python-nose
sudo apt-get install python3-dev

cd ~ ; git clone https://github.com/biopython/biopython.git
cd ~/biopython ; sudo python setup.py install # install in /usr/local/lib/python2.7/dist-packages/

pip3 install biopython

#check latest update: https://bitbucket.org/kleinstein/presto/downloads/
cd ~ ; wget https://bitbucket.org/kleinstein/presto/downloads/presto-0.5.2.tar.gz

sudo pip3 install presto-0.5.2.tar.gz
rm presto-0.5.2.tar.gz


#####################
#internet tools
sudo apt install curl whois nmap

sudo apt install filezilla thunderbird


### SSH
sudo apt install openssh-server openssh-client
sudo cp /etc/ssh/sshd_config  /etc/ssh/sshd_config.original_copy
nc -v -z 127.0.0.1 22 #test port 22
sudo nano /etc/ssh/sshd_config # change port from  22 to another, PermitRootLogin : no yes prohibit-password
sudo /etc/init.d/ssh restart

#no matching cipher found:
#client aes256-cbc,aes192-cbc,aes128-cbc,blowfish-cbc,cast128-cbc,arcfour256,arcfour128,3des-cbc
#server chacha20-poly1305@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr,aes128-gcm@openssh.com,aes256-gcm@openssh.com





#####################
# install R and RStudio
DISTRIB_CODENAME=`grep DISTRIB_CODENAME /etc/lsb-release | cut -f 2 -d "="`
#supported = xenial wily trusty precise
sudo add-apt-repository "deb https://cran.uni-muenster.de/bin/linux/ubuntu $DISTRIB_CODENAME"

#sudo add-apt-repository "deb https://cran.uni-muenster.de/bin/linux/ubuntu xenial" 

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
sudo apt-get install r-base r-base-dev r-base-html r-doc-html libjpeg62

# Get RStudio version
VERSION="$(curl -s "https://www.rstudio.com/products/rstudio/release-notes/" | grep "<h2>RStudio v" | awk '{print $2}' | sed -e 's/v//')"
if [ -z "$VERSION" ];then echo "Could not find automaticaly RStudio version, please check https://www.rstudio.com/products/rstudio and enter 0.99.473"; read VERSION; fi

processorType=$(arch)
if [ "$processorType" == "i386" ];then V="$VERSION-i386"; fi
if [ "$processorType" == "i686" ];then V="$VERSION-i386"; fi #http://download1.rstudio.org/rstudio-0.99.441-i386.deb
if [ "$processorType" == "x86_64" ];then V="$VERSION-amd64"; fi #http://download1.rstudio.org/rstudio-0.99.441-amd64.deb
wget http://download1.rstudio.org/rstudio-$V.deb
sudo dpkg -i rstudio-$V.deb
rm rstudio-$V.deb

#source("http://bioconductor.org/biocLite.R")
#biocLite("BiocUpgrade")

