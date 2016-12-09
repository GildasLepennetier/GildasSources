#!/usr/bin/env Rscript

# function to use as replacement of shazam::findThreshold
# very big approximation using median + two standard deviation.

##################################################
# Gildas Lepennetier 2016.11.22
library(shazam,q=T)
library(alakazam,q=T)
MODEL=c(" hs1f", "hs5f", "ham", "aa", "m1n", "m3n")[3]
ARGS=commandArgs(TRUE)
if(length(ARGS) < 1){
	write("threshold approximation by: median + 1.5*sd", stderr())
	write(paste("Using model of distance:",MODEL), stderr())	
	write(paste("usage: Rscript --vanilla <script threshold_perso> <files ...>"), stderr())
}else{
	for (file in ARGS){
		if(file.exists(file)){
			db <- readChangeoDb(file)
			db <- distToNearest(db, model=MODEL, first=FALSE)
			threshold_perso = median(db$DIST_NEAREST,na.rm=T) + 1.5*sd(db$DIST_NEAREST,na.rm=T)
			write(paste(signif(threshold_perso,4),basename(file)), stdout())
		}else{
			write(paste("NA",file), stderr())
		}
	}
	quit("no")
}
