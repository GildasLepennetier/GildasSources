#!/bin/bash
#coding:utf-8

#==============================
#	DESCRIPTION
#==============================

	# too much disk access: need ram
	# random sorting: too much efforts ( | sort -R )
	# limit to a domain / a depth of X
	# 
	
#epoch: Jan 1 1970
	
#==============================
#	VARIABLES
#==============================
mydb="domains_db.txt"
todo="domains_todo.txt"
explored="domains_explored.txt"

maxtime=$1
if [ -z $maxtime ];then maxtime=10; fi

#==============================
#	FUNCTIONS
#==============================

# usage function
usage(){
cat << EOF
	usage: $(basename $0)
	----
	Explore domains
	Extract external and internal links
	Create a domains database
	----
EOF
}

# get list of links from a url, url is $1
getLinksFromURL(){ 
curl $1 --silent --compressed --fail --max-time 60 --retry 3 --retry-delay 10 | 
grep -E "href=['\"]{1}([^ #&?]*)['\"]{1}" --only-matching --no-messages | 
sed -e "s/href=//g" -e "s/'//g" -e "s/\"//g" -e "s/\/$//g"
}

# from the list given in pipe, print only external links to domain $1
getExternLinks(){ 
while read data
do 
echo $data | 
grep -e "http://" -e "https://" -e "ftp://" | 
grep -v -e "$1"
done
}
getInternalLinks(){ 
while read data
do 
echo $data | grep -e "$1" #for the link fully made
echo $data | grep -ve "$1" | grep -ve "http://" -ve "https://" -ve "ftp://" | awk "{print \"$1\" \"/\" \$0}"
done
}

# get a domain name from a link
getBaseDomain(){
	suffix=${1##*//} 
	echo "${1%%//*}//${suffix%%/*}"
}
#getBaseDomain https://soutien.laquadrature.net/tefr/dfsf/

# select 1 random lines from a file, file is $1
#getRandom(){ sort -R "$1" | head -n 1; }




#==============================
#	MAIN
#==============================

# initialization databases
if [ ! -e "$mydb" ];then 
	echo "no $mydb file found..."
	read -p "please enter an url: " url
	if curl --output /dev/null --silent --head --fail "$url"; then
		echo "init $mydb"
		echo -e "url\tepoch" > "$mydb"
		echo "url added to $todo"
		echo "$url" >> "$todo"
	else
		echo "url does not exist, aborded"; exit 1
	fi
fi
# check if file exist
if [ ! -e "$explored" ];then touch "$explored"; fi

# explore first domain in list


starttime=$(date +%s)
echo "start: $(date)"
endtime=$(($starttime + $maxtime))
while [ 0 ]; do
	total=$(cat "$todo" | wc -l)
	for k in $(seq 1 $total)
	do
		if [ $(date +%s) -gt  $endtime ];then echo -e "\nend of time ($maxtime s)"; echo "end: $(date)"; exit 1; fi
		currentLink=$(head -n 1 "$todo")
		if ! grep -q "$currentLink" "$explored";then 
			echo "$currentLink" >> "$explored"
			currentDomain=$(getBaseDomain "$currentLink")

			echo -en "\r$k / $total\t- spider on $currentLink\033[0K"
			
			links_all=$(getLinksFromURL "$currentLink")
			#echo -e "\n\t External links:"
			echo "$links_all" | getExternLinks "$currentDomain" | grep -i -e".php" -e".html" >> "$todo" #ifexternal link, put in todo list
			#echo -e "\n\t Internal links:"
			echo "$links_all" | getInternalLinks "$currentDomain" | grep -i -e".php" -e".html" >> "$todo"
			cat "$todo" | sort | uniq > "$todo.tmp"
			mv "$todo.tmp" "$todo"
			#if not found, added
			if ! grep -q "$currentDomain" "$mydb";then echo -e "$currentDomain\t$(date +%s)" >> "$mydb"; fi
			#echo -e "\n\t Internal pictures:"
			#echo "$links_all" | getInternalLinks $currentDomain | grep -i -e".bmp" -e".gif" -e".png" -e".jpg" -e".jpeg" -e".tiff"
			#echo -e "\n\t Internal XML:"
			#echo "$links_all" | getInternalLinks $currentDomain | grep -i -e"xml"
			# once exploration finished, remove from list
			tail -n +2 "$todo" > "$todo.tmp" && mv "$todo.tmp" "$todo"
		else
			tail -n +2 "$todo" > "$todo.tmp" && mv "$todo.tmp" "$todo"
		fi
	done
done
echo "end: $(date)"


