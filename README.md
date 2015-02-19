

<h1>GildasSources</h1>



<h2>DESCRIPTION</h2>

<p>A selection of useful functions related to bioinformatic studies and linux tools</p>



INSTALLATION

<p>GildasSources does not require an installation. Just add the directory in the PATH, and give the execution rights.</p>
<ul>
<li>Exemple of commandes:</li>
<li>echo -e "#GildasSources\nPATH=$PATH:$(pwd)" >> ~/.bashrc</li>
<li>sudo chmod +x *</li>
</ul>


<h2>MANUAL</h2>

<p>The function have an integrated help function. Just call is from the terminal. </p>
<ul>
<li>Exemple:</li>
<li>myfunction -h</li>
</ul>
<p>I am also trying to make them pipeble, fo they can take the stdin from a previous function redirected with a pipe ( | ). In some cases, it's not avalable, in other case not possible, and sometime you will have to give the option ( - )</p>
