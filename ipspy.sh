IPbase="ip.list"
server="http://gildas.idi-informatique.fr/ip.php"
wget $server -q -O - |
grep -Po '((25[0-5]|2[0-4][0-9]|[01]?[1-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[1-9][0-9]?)' >> "$IPbase"
cat "$IPbase" | sort | uniq > "$IPbase.tmp"
mv "$IPbase.tmp" "$IPbase"