主机
ping 172.29.50.41 | head -n 20 | gawk '/time/ {split($7, ss, "="); sum+=ss[2]; count+=1;} END{print sum
/count "ms";}'
0.46ms

跨node容器内
ping 10.44.171.47 | head -n 20 | gawk '/time/ {split($7, ss, "="); sum+=ss[2]; count+=1;} END{print sum
/count "ms";}'
0.607263ms

同node容器内
0.601316ms