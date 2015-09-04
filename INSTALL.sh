#!/bin/bash -e
# Script to include the current directory in he path (Linux), and set execution permissions.
# Copyright 2015 LEPENNETIER Gildas
# Author: Gildas Lepennetier - gildas.lepennetier@hotmail.fr
echo "#====================================="
echo "# installation (linux)"
echo "# -> execution right"
echo "# -> update PATH variable"
echo "#====================================="
ADD="$(pwd)" #in case we want another directory
if [ ! -e $HOME/.bashrc ];then echo "No .bashrc file in the home directory -> this script is useless";exit 1;fi
echo "giving execution rights"
read -p "press enter to continue, ctrl+c to cancel"
chmod +x *
echo "exporting current directory"
read -p "press enter to continue, ctrl+c to cancel"
export PATH="$PATH:$ADD"
#add current path
echo "Updating $HOME/.bashrc file (append at the end)"
read -p "press enter to continue, ctrl+c to cancel"
echo -e "\n#GildasSources funtions\nPATH=\$PATH:$ADD" >> $HOME/.bashrc
echo "DONE. Please execute this script only once, or you will have to clean your .bashrc file..."