GildasSources
================================

DESCRIPTION

GildasSources is a collection of bioinformatic tools

INSTALLATION

GildasSources does not require an installation.
Just add the directory in the PATH, and give the execution rights.
Exemple of commandes:

> # add the directory to the PATH
> echo -e "#GildasSources\nPATH=$PATH:$(pwd)" >> ~/.bashrc 

> # give execution rights
> sudo chmod +x * 

> # reload the shell to update the PATH variable
> bash 

NOTES

All functions are called from the terminal, since they are on the PATH env variable
All functions have integrated help. Exemple:

> # display help for joinsep
> joinsep -h

I am trying to make those functions "pipeble"
This means that they are able to take the stdin from a previous function 
and to be redirected with a pipe ( | ) to another one.
!! careful: not all of them have this hability.

Use the -author option when available to contact me.
