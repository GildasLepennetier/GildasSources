GildasSources
========
DESCRIPTION
================================
GildasSources is a collection of bioinformatic tools


INSTALLATION
================================
GildasSources does not require an installation.
Just add the directory in the PATH, and give the execution rights.
Exemple of commandes:
> echo -e "#GildasSources\nPATH=$PATH:$(pwd)" >> ~/.bashrc # add the directory to the PATH
> sudo chmod +x * # give execution rights
> bash # reload the shell

NOTES
================================
The function have an integrated help function. Just call is from the terminal. Exemple:
myfunction -h
I am trying to make those functions pipeble, so they can take the 
stdin from a previous function redirected with a pipe ( | ).

In some cases, it's not available, in other case not possible.
Please check the help, or ask me in case of trouble, 
my contact is provided on the help ( -h ), or in the ( -author ) option.
