#!/bin/bash
#coding:utf-8

#==============================
#	VARIABLES
#==============================
VERSION="1.0"
AUTHOR="Author: Gildas Lepennetier - gildas.lepennetier@hotmail.fr"
COPY="Copyright 2015 LEPENNETIER Gildas"
CREATION="13 March 2015"

mydb="domains_db.txt"
todo="domains_todo.txt"
explored="domains_explored.txt"
DEPTH=1
if [ $DEPTH -gt 1 ];then buffer1=$(mktemp -p $(pwd)); fi
keep_tmp_in_todo=true
maxtime=600 #default: 10 minutes

#==============================
#	FUNCTIONS
#==============================

# usage function
usage(){
cat << EOF
	usage: $(basename $0) url [-h]
	
	A spider for the big web.
	
	DESCRIPTION
	
	Explore web domains from a todo file ($todo)
	Extract external and internal links
	Create a domains database ($mydb)
	Keep track of explored links ($explored)
	Can crawl with different depth (default: $DEPTH)
	Stop if taking too long (max time: $maxtime)
	
	ARGUMENTS

	-h		print help
	
-----------------------
	$AUTHOR
	Version $VERSION - Creation $CREATION
	$COPY
EOF
}

# get list of links from a url, url is $1
getLinksFromURL(){ curl $1 --silent --compressed --fail --max-time 15 --retry 3 --retry-delay 10 | grep -E "href=['\"]{1}([^ #&?]*)['\"]{1}" --only-matching --no-messages | sed -e "s/href=//g" -e "s/'//g" -e "s/\"//g" -e "s/\/$//g";}

# from the list given in pipe, print only external links to domain $1
getExternLinks(){ 
while read data;do 
echo $data | 
grep -e "http://" -e "https://" -e "ftp://" | 
grep -v -e "$1"
done ;}

# from the list given in pipe, print only internal links to domain $1 / create link if relative path
getInternalLinks(){ 
while read data;do 
echo $data | grep -e "$1" #for the link fully made
echo $data | grep -ve "$1"|grep -ve "http://" -ve "https://" -ve "ftp://"|sed '1s/^\///'|awk "{print \"$1\" \"/\" \$0}"
done;}

# get a domain name from a link
getBaseDomain(){ suffix=${1##*//};echo "${1%%//*}//${suffix%%/*}";}

# use curl to know if url exist
urlExists(){ curl --output /dev/null --silent --head --fail "$1";}

# select 1 random lines from a file, file is $1
getRandom(){ sort -R "$1"|head -n 1;}

#==============================
#	MAIN
#==============================
#print usage is asked
if [ "$1" == "-h" ];then usage;exit;fi

url=$1

#check given url, if ok add to todo list
if urlExists "$url"; then echo "$url" >> "$todo"; else echo -e "No url / Bad url\nPlease give an url as first argument, of -h for help"; exit 1; fi

if [ $(cat "$todo" | wc -l) -eq 0 ];then echo -e "Nothing in todo file ($todo)\nend: $(date)"; exit 1; fi

# initialization databases if not existing
if [ ! -e "$mydb" ];then echo "init $mydb"; echo -e "url\tepoch" > "$mydb" ;fi

# need to create a file of explored links, to grep in something
if [ ! -e "$explored" ];then touch "$explored";fi

starttime=$(date +%s)
echo "start: $(date)"
endtime=$(($starttime + $maxtime))

DEPTH=$(($DEPTH+1)) #need to increase, so we really make two round

# explore until run out of time
while [ 0 ]; do
	total=$(cat "$todo" | wc -l) #nb of lines in todo file
	for k in $(seq 1 $total) #for each line
	do
		if [ $(date +%s) -gt  $endtime ];then 
			if [ "$keep_tmp_in_todo" == "true" ];then cat "$buffer1" >> "$todo";fi
			rm -f "$buffer1"
			echo -e "\nend of time ($maxtime s) $(date)"
			echo -e "\nend: $(date)"
			exit 1
		fi #stop if take too long
		
		currentLink=$(head -n 1 "$todo")
		if ! grep -q "$currentLink" "$explored";then 
			currentDomain=$(getBaseDomain "$currentLink"); echo -en "\r$k / $total - spider on $currentLink - depth=$DEPTH\033[0K"
			links_all=$(getLinksFromURL "$currentLink")
			#get links on the page
			echo "$links_all" | getInternalLinks "$currentDomain" | grep -i -e".php" -e".html" >> "$todo" #links to page / internals
			if [ $DEPTH -gt 1 ];then echo "$links_all" | getExternLinks "$currentDomain" | grep -i -e".php" -e".html" >> "$buffer1"; fi #links to pages / external
			#if domain is new, added in db
			if ! grep -q "$currentDomain" "$mydb";then
				echo -e "$currentDomain\t$(date +%s)" >> "$mydb"
			fi
			#echo "$links_all" | getInternalLinks $currentDomain | grep -i -e".bmp" -e".gif" -e".png" -e".jpg" -e".jpeg" -e".tiff" #pictures
			#echo "$links_all" | getInternalLinks $currentDomain | grep -i -e"xml" #feeds
			echo "$currentLink" >> "$explored"
			tail -n +2 "$todo" | sort -R | uniq > "$todo.tmp" && mv "$todo.tmp" "$todo" # once exploration finished, remove from todo list / avoid duplicates
		else
			tail -n +2 "$todo" | sort -R | uniq > "$todo.tmp" && mv "$todo.tmp" "$todo" # if already visited, remove from todo list / avoid duplicates
		fi
	done
	if [ $DEPTH -gt 1 ];then 
		cat "$buffer1" >> "$todo" #add the discovered external links in the todo list
		rm "$buffer1"
		DEPTH=$(($DEPTH-1)) #reduce depth, since already explored
	fi #links to pages / external
	if [ $(cat "$todo" | wc -l) -eq 0 ];then echo -e "\nend: $(date)"; exit; fi
done
if [ "$keep_tmp_in_todo" == "true" ];then cat "$buffer1" >> "$todo";fi
rm -f "$buffer1"