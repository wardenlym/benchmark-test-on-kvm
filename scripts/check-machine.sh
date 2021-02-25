
CPU_NUM=`egrep -c '(vmx|svm)' /proc/cpuinfo`
echo "CPU core num: $CPU_NUM"