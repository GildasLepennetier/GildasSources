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



# system
sudo apt install kate
sudo apt install python3-pip



#bioinfo
sudo apt install tophat bowtie 
sudo apt install ncbi-blast+
sudo apt install bedtools


# SRA-toolkit
cd ~ ; wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.7.0/sratoolkit.2.7.0-ubuntu64.tar.gz
tar -xvf sratoolkit.2.7.0-ubuntu64.tar.gz
echo add ~/sratoolkit.2.7.0-ubuntu64/bin to the PATH



# pRESTO : 
sudo apt-get install python-numpy python-scipy python-matplotlib ipython ipython-notebook python-pandas python-sympy python-nose
cd ~ ; git clone https://github.com/biopython/biopython.git
cd ~/biopython ; sudo python setup.py install # install in /usr/local/lib/python2.7/dist-packages/
#check latest update: https://bitbucket.org/kleinstein/presto/downloads/
cd ~ ; wget https://bitbucket.org/kleinstein/presto/downloads/presto-0.5.2.tar.gz
pip3 install presto-0.5.2.tar.gz




#internet tools
sudo apt install curl whois nmap
sudo apt install openssh-server filezilla thunderbird


# install R and RStudio
DISTRIB_CODENAME=`grep DISTRIB_CODENAME /etc/lsb-release | cut -f 2 -d "="`
#supported = xenial wily trusty precise
sudo add-apt-repository "deb https://cran.uni-muenster.de/bin/linux/ubuntu $DISTRIB_CODENAME"
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

