#!/bin/bash -e
# Script to include the current directory in he path (Linux), and set execution permissions.
# Copyright 2015 LEPENNETIER Gildas
# Author: Gildas Lepennetier - gildas.lepennetier@hotmail.fr
echo "#====================================="
echo "# installation (linux)"
echo "# -> execution right"
echo "# -> update PATH variable"
ADD="$(pwd)" #in case we want another directory
if [ ! -e $HOME/.bashrc ];then echo "No .bashrc file in the home directory -> this script is useless";exit 1;fi
P=$(grep "#GildasSources funtions" "$HOME/.bashrc")
if [ -z "$P" ];then echo "Updating $HOME/.bashrc file and export PATH variable"
	read -p "press enter to continue, ctrl+c to cancel"
	echo -e "PATH=\$PATH:$ADD #GildasSources funtions - do not modify this line" >> $HOME/.bashrc
	export PATH="$PATH:$ADD"
else
	echo ".bashrc file in $(pwd) already up to date"
fi

echo "Giving execution rights to files in $(pwd)"
read -p "press enter to continue, ctrl+c to cancel"
sudo chmod +x *
echo "DONE."
echo "#====================================="