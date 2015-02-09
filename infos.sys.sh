#/bin/bash
echo -e "START"
function repchar(){ printf "%0.s#" {1..80}; echo;} #function to repeat a char several time

repchar
echo "# Info partitions"
cat  /etc/fstab

repchar
echo "# Ethernet"
ifconfig -a

repchar
echo "# Processors"
cat /proc/cpuinfo | grep processor | wc -l
cat /proc/cpuinfo | grep "model name" |sort|uniq
cat /proc/cpuinfo | grep "cpu MHz" |sort|uniq


repchar
echo "# hardware"
lspci

repchar
echo "# Free space:"
df -hT

repchar
echo "# Informations bout the system:"
uname -a
cat /proc/version

repchar
echo "PBS (bortable batch system)"

echo -e "END"
qmgr -c "print server"

