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
CMD='chmod +x *'
echo "giving execution rights || $CMD"
$CMD
CMD='export PATH="$PATH:$ADD"'
echo "exporting current directory || $CMD"
$CMD
#add current path
echo "Updating $HOME/.bashrc file (append at the end)"
echo "#GildasSources funtions" >> $HOME/.bashrc
echo "PATH=\$PATH:$ADD" >> $HOME/.bashrc
