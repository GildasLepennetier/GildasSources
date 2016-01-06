##DESCRIPTION

GildasSources is a collection of bioinformatic tools.
Everything was developped by the author on Linux Mint, and then may encounter problems runing elsewhere.

##INSTALLATION

GildasSources contain a INSTALL.sh file, run it to start the installation.
> cd $HOME/GildasSources
> bash INSTALL.sh

The installation will basicaly just add the directory in the PATH, and give execution rights.
Once you did this installation step, you can call the functions from the terminal.

##UPDATE

You can use the set_env.sh script to install additionnal bioinformatics tools.
> bash set_env.sh

##USAGE

All functions are called from the terminal, since they are on the PATH environment variable
Exemple: 
> joinsep
> joinsep - 1 2 3

All functions have an integrated help. 
Exemple: display help for fasta_toolkit
> fasta_toolkit -h

##NOTES

I am trying to make those functions "pipeble"
This means that they are able to take the stdin from a previous function 
and to be redirected with a pipe ( | ) to another one.
!! careful: not all of them have this hability.

##CONTACT

Use the -author option when available to contact me.
