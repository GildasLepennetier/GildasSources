# arrange a df arrange()
if(!require("plyr",quietly=T)){ install.packages("plyr", dependencies=T) };library("plyr",quietly=T)
# if error on linux: in terminal: sudo apt-get install r-cran-plyr")
# rolling function (rollaply)
if(!require("zoo",quietly=T)){ install.packages("zoo",dependencies=T) };library("zoo",quietly=T)
# partial correlation pcor()
if(!require("ppcor",quietly=T)){install.packages("ppcor",dependencies=T)};library("ppcor",quietly=T)
# R.utils: usefull tools
if(!require("R.utils",quietly=T)){ install.packages("R.utils", dependencies=T) };library("R.utils",quietly=T)
# session
if(!require("session",quietly=T)){ install.packages("session", dependencies=T) };library("session",quietly=T)
# graphs ggplot2
if(!require("ggplot2",quietly=T)){ install.packages("ggplot2", dependencies=T) };library("ggplot2",quietly=T)
# function modal()
#if(!require("raster",q=T)){install.packages("raster",dependencies=T)};library("raster",q=T)
# function quantcut()
if(!require("gtools",quietly=T)){install.packages("gtools",dependencies=T)};library("gtools",quietly=T)
# violin plot vioplot()
#if(!require("vioplot",q=T)){install.packages("vioplot",dependencies=T)};library("vioplot",q=T)
# bag plot bagplot()
#if(!require("aplpack",q=T)){install.packages("aplpack",dependencies=T)};library("aplpack",q=T)
# principal componant analysis, PCA dudi.pca
#if(!require("ade4",q=T)){install.packages("ade4",dependencies=T)};library("ade4",q=T)
# foreach, parallel loops
if(!require("foreach",quietly=T)){install.packages("foreach",dependencies=T)};library("foreach",quietly=T)
#===============================================
# to use devel tools
install.packages(c("devtools", "roxygen2", "testthat", "knitr", "rmarkdown", "Rcpp"))
#===============================================


# functions
count=function(v){return(length(na.omit(v)))}
breadth=function(v,lim=F){if(lim){v=v[v<lim]};return(length(na.omit(v))/length(v))}
TSI=function(v,w=F){v=na.omit(v);if(length(v)<2){if(w){write("Error in TSI: you need a vector of size > 1",stderr())};return(NA)};if(!sum(v!=0)){write("Error in TSI: 1 value should be different than 0",stderr());return(NA)};return(sum(1-(v/max(v)))/(length(v)-1))} #tissue specificity index from Yanai 2005, min=0, max=1, > 1tissue, 1 value !=0
stars=function(p.value,limits=c(0.05,0.01,0.001),sign=2,NS=T){if(NS){star="NS"}else{star=signif(p.value,sign)}; if(p.value<limits[1]){star="*"};if(p.value<limits[2]){star="**"};if(p.value<limits[3]){star="***"};return(star)}
sampleRows = function(df,n,r=T){return(df[sample(nrow(df),n,replace=r),])} #sample n rows in a df, with/wo replacement
#you can give to asymmetry two verctor of count, but not two vector of position, carefull !
asymmetry=function(sens,anti){if(length(sens)!=length(anti)){print("Error: sens and anti should have the same length",stderr());return(NA)};s=sum(sens);a=sum(anti);if(s==0&a==0){return (0)}else{return((s-a)/(s+a))}}#take into account 0 obs in both strands, and work with vectors or integers
motif_from_end=function(L,V){ #L=list with positionS of PA in exon - V=vector of exon size as reference
	if(length(L)!=length(V)){write("Error, list and vector should be of same length",stderr())}
	OUT=c()
	for (kk in 1:length(V)){
		l=as.integer(L[[ kk ]]) # get list of position
		v=as.integer(V[  kk  ]) # get corresponding gene size
		if(length(l)==0){OUT=c(OUT,NA)}
		if(length(l)==1){OUT=c(OUT, v-l )}
		if(length(l)>1){l=l[length(l)];OUT=c(OUT, v-l )}#only the last poly-A in exon
	}
	return(OUT)
}
motif_first=function(L){ #L=list with positionS of PA in exon - V=vector of exon size as reference
	OUT=c()
	for (kk in 1:length(L)){
		l=as.integer(L[[ kk ]]) # get list of position
		if(length(l)==0){OUT=c(OUT,NA)}
		if(length(l)==1){OUT=c(OUT, l )}
		if(length(l)>1){l=l[1];OUT=c(OUT, l )}#only the last poly-A in exon
	}
	return(OUT)
}
motif_last=function(L){ #L=list with positionS of PA in exon - V=vector of exon size as reference
	OUT=c()
	for (kk in 1:length(L)){
		l=as.integer(L[[ kk ]]) # get list of position
		if(length(l)==0){OUT=c(OUT,NA)}
		if(length(l)==1){OUT=c(OUT, l )}
		if(length(l)>1){l=l[length(l)];OUT=c(OUT,l)}#only the last poly-A in exon
	}
	return(OUT)
}
motif_expand=function(L,split=",",toint=F){
	OUT=c()
	for (kk in 1:length(L)){
		OUT=c(OUT, unlist(  strsplit(L[kk],split = split) ) )
	}
	if(toint){
		return( as.integer(OUT) )
	}else{
		return( OUT )
	}
}
alignWords = function(l1,l2,sep=" ",minspace=2){
	if(minspace<0){simpleError("error, minimum space is 0")}
	M1 =nchar(l1)
	M2 =nchar(l2)
	MAX = max(M1)+max(M2)+minspace
	DIFF = MAX - (M1+M2)
	l3 = sapply(X = DIFF, FUN = function(x,sep){return(paste0(rep(sep,x),collapse=""))}, sep)
	return( paste0( l1, l3, l2 ) )
}

# calculate the position in percentage from start using position of motif, size of element. If several motif, use all="all"
motif_percent_from_start=function(L,V,all="all"){
	#L=list with positionS of PA in exon - V=vector of size as reference
	if(length(L)!=length(V)){write("Error, list and vector should be of same length",stderr());return(NA)}
	OUT=c()
	for (kk in 1:length(V)){
		l=as.integer(L[[ kk ]]) # get list of position
		v=as.integer(V[  kk  ]) # get corresponding gene size
		if(length(l)==0){OUT=c(OUT,NA)} # keep NA if no motif
		if(length(l)==1){OUT=c(OUT, l/v )} # if one motif, it's fine
		# if more than one motif:
		if(length(l)>1){
			if(all=="all"){
				for( xx in l){
					OUT=c(OUT,  xx /v ) # need to calculate the percentage relative to each reference size
				}
			}
			if(all=="first"){
				l=l[1] #select first
				OUT=c(OUT,  l/v )
			}
			if(all=="last"){
				l=l[length(l)] #select last
				OUT=c(OUT,  l/v )
			}#only the last poly-A in exon
		}
	}
	#
	return(OUT)
}
#extract attribute from a GFF file
ExtactMatch = function(string,field="gene_id",sep=" ",pattern="[[:alnum:]]*"){
	Regexp <- paste0(field,sep,pattern) #create the regexp to match
	MATCH=regmatches(string,regexpr(Regexp,string)) #extract the match using the regexp
	return(strsplit(x=MATCH,split=sep,fixed=T)[[1]][2]) #print the match described in pattern attribute
	"USAGE: Give a string, this function will extract the pattern associated with the field after a sep.
	author: Gildas Lepennetier 2015
	"
}
#extract all attribute from a GFF file
getAttributeField = function(attributes,field="gene_id",sep=" ",pattern="[[:alnum:]]*"){
	return( sapply(X=attributes,FUN=ExtactMatch,field,sep,pattern,USE.NAMES=F))#do not use name, we want only the match
	"USAGE: Give a vector of GFF attribute.
	This function will extract the pattern associated with the field after a sep.
	author: Gildas Lepennetier 2015
	"
}
# reverse a string
reverse=function(string){return(sapply(lapply(strsplit(string, NULL), rev), paste, collapse=""))}
# complement
complement=function(string, type="DNA"){
	DNA=function(letter){
		if(letter=="A") comp<-"T"
		if(letter=="C") comp<-"G"
		if(letter=="G") comp<-"C"
		if(letter=="T") comp<-"A"
		if(letter=="a") comp<-"t"
		if(letter=="c") comp<-"g"
		if(letter=="g") comp<-"c"
		if(letter=="t") comp<-"a"
		if(letter=="Y") comp<-"R"
		if(letter=="y") comp<-"r"
		if(letter=="R") comp<-"Y"
		if(letter=="r") comp<-"y"
		if(letter=="S") comp<-"S"
		if(letter=="s") comp<-"s"
		if(letter=="W") comp<-"W"
		if(letter=="w") comp<-"w"
		if(letter=="K") comp<-"M"
		if(letter=="k") comp<-"m"
		if(letter=="M") comp<-"K"
		if(letter=="m") comp<-"k"
		if(letter=="B") comp<-"V"
		if(letter=="b") comp<-"v"
		if(letter=="D") comp<-"H"
		if(letter=="d") comp<-"h"
		if(letter=="H") comp<-"D"
		if(letter=="h") comp<-"d"
		if(letter=="V") comp<-"B"
		if(letter=="v") comp<-"b"
		if(letter=="N") comp<-"N"
		if(letter=="n") comp<-"n"
		return(comp)
	}
	RNA=function(letter){
		if(letter=="A") comp<-"U"
		if(letter=="C") comp<-"G"
		if(letter=="G") comp<-"C"
		if(letter=="U") comp<-"A"
		if(letter=="a") comp<-"u"
		if(letter=="c") comp<-"g"
		if(letter=="g") comp<-"c"
		if(letter=="u") comp<-"a"
		if(letter=="Y") comp<-"R"
		if(letter=="y") comp<-"r"
		if(letter=="R") comp<-"Y"
		if(letter=="r") comp<-"y"
		if(letter=="S") comp<-"S"
		if(letter=="s") comp<-"s"
		if(letter=="W") comp<-"W"
		if(letter=="w") comp<-"w"
		if(letter=="K") comp<-"M"
		if(letter=="k") comp<-"m"
		if(letter=="M") comp<-"K"
		if(letter=="m") comp<-"k"
		if(letter=="B") comp<-"V"
		if(letter=="b") comp<-"v"
		if(letter=="D") comp<-"H"
		if(letter=="d") comp<-"h"
		if(letter=="H") comp<-"D"
		if(letter=="h") comp<-"d"
		if(letter=="V") comp<-"B"
		if(letter=="v") comp<-"b"
		if(letter=="N") comp<-"N"
		if(letter=="n") comp<-"n"
		return(comp)
	}
	if(type=="DNA") {
		tryCatch(expr = return( paste(unlist(lapply( unlist(strsplit(string,NULL)) , DNA) ),collapse="")), error = function(w){print("Error: this is not DNA")})
		}
	if(type=="RNA") {
		tryCatch(expr = return( paste(unlist(lapply( unlist(strsplit(string,NULL)) , RNA) ),collapse="")), error = function(w){print("Error: this is not RNA")})
		}
}
# reverse complement
reverseComplement=function(string, type="DNA"){return(complement(reverse(string),type=type))}
# test 	reverseComplement( "ATG" ) == "CAT"

values_between = function(string,start,end,sep=','){
    line = as.integer( unlist( strsplit(string,fixed=T,split=sep) ) )
    return( line[ line >= start & line <= end ] )
    #from a string coma separated integer ('1,2,50,100')-> return vector of integer in range start-end (ex: start = 2, will remove value 1)
}

values_between_count=function( V, start, end ){
    return(count(unlist( foreach(line = V ) %do%  values_between(line, start, end) )))
    #given a column (can contain NA), return the count of motifs between start and end
}
#map element of a vectors without duplicates
pair_map=function(elements){V1=c();V2=c();for (index1 in 1:(length(elements)-1) ){for ( index2 in ((index1+1):length(elements))){V1=c(V1,elements[ index1]);V2=c(V2,elements[ index2]);};};return(list(elements1=V1,elements2=V2))}

hamming=function(str1, str2){return( sum(strsplit(str1,split = "",fixed = T)[[1]] != strsplit(str2,split = "",fixed = T)[[1]]))}
