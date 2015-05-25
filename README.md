

<h1>GildasSources</h1>
<h2>DESCRIPTION</h2>
<p>GildasSources is a collection of useful functions related to bioinformatic studies in a linux environment. Use include NGS, fasta, annotation, work simplification and file handeling tools.</p>
<p>Workflows are yet not available, since the analysis are currently running.</p>


<h2>INSTALLATION</h2>
<p>GildasSources does not require an installation. Just add the directory in the PATH, and give the execution rights. Exemple of commandes:</p>
<ul>
<li>echo -e "#GildasSources\nPATH=$PATH:$(pwd)" >> ~/.bashrc # add the directory to the PATH</li>
<li>sudo chmod +x * # give execution rights</li>
<li>bash # reload the shell</li>
</ul>

<h2>MANUAL</h2>

<p>The function have an integrated help function. Just call is from the terminal. Exemple:</p>
<ul>
<li>myfunction -h</li>
</ul>
<p>I am trying to make those functions pipeble, so they can take the stdin from a previous function redirected with a pipe ( | ). In some cases, it's not available, in other case not possible, and sometime you will have to give the option ( - ). Please check the help, or ask me in case of trouble, my contact is provided on the help ( -h ), or in the ( -author ) option.</p>
