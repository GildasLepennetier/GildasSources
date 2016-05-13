#/bin/bash
function repchar(){ printf "%0.s#" {1..80}; echo;} #function to repeat a char several time

repchar
echo -e "\nInfo partitions"
cat  /etc/fstab

repchar
echo -e "\nEthernet"
ifconfig -a

repchar
echo -e "\nhardware"
lspci

repchar
echo -e "\nFree space:"
df -hT

repchar
echo -e "\nSystem information"
uname -a
cat /proc/version

repchar
echo -e "\nProcessors"
cat /proc/cpuinfo | grep processor | wc -l
cat /proc/cpuinfo | grep "model name" |sort|uniq
cat /proc/cpuinfo | grep "cpu MHz" |sort|uniq

