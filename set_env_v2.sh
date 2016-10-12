#!/bin/bash

################################################################################
#
#	Install tools for a functional Linux environment
#
################################################################################

################################################################################

# git
sudo apt install git
cd ~ ; git clone https://github.com/GildasLepennetier/GildasSources.git
cd ~ ; git clone https://github.com/brentp/bio-playground.git


# system
sudo apt install kate

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



#bioinfo
sudo apt install tophat bowtie ncbi-blast+ bedtools
sudo apt install muscle
sudo apt install libboost-all-dev
sudo apt install fastx-toolkit

sudo wget -nc http://cancan.cshl.edu/labmembers/gordon/fastq_illumina_filter/release/0.1/fastq_illumina_filter-Linux-x86_64 -P /usr/local/bin
sudo chmod 755 /usr/local/bin/fastq_illumina_filter-Linux-x86_64



# SRA-toolkit
sudo apt install sra-toolkit



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





curl -kL http://install.perlbrew.pl | bash


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



#internet tools
sudo apt install curl whois nmap
#sudo apt install openssh-server filezilla thunderbird



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

