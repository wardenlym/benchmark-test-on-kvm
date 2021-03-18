```
root@ubuntu-test-rpv4l:/# iperf3 -sp 12345
-----------------------------------------------------------
Server listening on 12345
-----------------------------------------------------------
Accepted connection from 10.44.202.225, port 45652
[  5] local 10.44.171.47 port 12345 connected to 10.44.202.225 port 45654
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec   246 MBytes  2.06 Gbits/sec                  
[  5]   1.00-2.00   sec   402 MBytes  3.37 Gbits/sec                  
[  5]   2.00-3.00   sec   304 MBytes  2.55 Gbits/sec                  
[  5]   3.00-4.00   sec   278 MBytes  2.33 Gbits/sec                  
[  5]   4.00-5.00   sec   260 MBytes  2.18 Gbits/sec                  
[  5]   5.00-6.00   sec   368 MBytes  3.08 Gbits/sec                  
[  5]   6.00-7.00   sec   315 MBytes  2.64 Gbits/sec                  
[  5]   7.00-8.00   sec   295 MBytes  2.48 Gbits/sec                  
[  5]   8.00-9.00   sec   335 MBytes  2.81 Gbits/sec                  
[  5]   9.00-10.00  sec   276 MBytes  2.32 Gbits/sec                  
[  5]  10.00-10.00  sec  1.13 MBytes  2.37 Gbits/sec                  
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-10.00  sec  3.01 GBytes  2.58 Gbits/sec                  receiver
-----------------------------------------------------------
Server listening on 12345
-----------------------------------------------------------
^Ciperf3: interrupt - the server has terminated
```

iperf3 -c 10.44.171.47 -p12345 -i1 -M 1460

容器内跨node

```
root@ubuntu-test-9qch2:/# iperf3 -c 10.44.171.47 -p12345 -i1 -M 1440
Connecting to host 10.44.171.47, port 12345
[  5] local 10.44.37.250 port 57104 connected to 10.44.171.47 port 12345
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec   292 MBytes  2.45 Gbits/sec  158   2.18 MBytes       
[  5]   1.00-2.00   sec   295 MBytes  2.47 Gbits/sec  563   2.26 MBytes       
[  5]   2.00-3.00   sec   280 MBytes  2.35 Gbits/sec  164   2.34 MBytes       
[  5]   3.00-4.00   sec   286 MBytes  2.40 Gbits/sec    0   2.43 MBytes       
[  5]   4.00-5.00   sec   286 MBytes  2.40 Gbits/sec  180   1.81 MBytes       
[  5]   5.00-6.00   sec   285 MBytes  2.39 Gbits/sec  316   1.91 MBytes       
[  5]   6.00-7.00   sec   285 MBytes  2.39 Gbits/sec  495   2.00 MBytes       
[  5]   7.00-8.00   sec   279 MBytes  2.34 Gbits/sec   26   2.10 MBytes       
[  5]   8.00-9.00   sec   265 MBytes  2.22 Gbits/sec  303   2.18 MBytes       
[  5]   9.00-10.00  sec   279 MBytes  2.34 Gbits/sec  355   1.65 MBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  2.77 GBytes  2.38 Gbits/sec  2560             sender
[  5]   0.00-10.00  sec  2.76 GBytes  2.37 Gbits/sec                  receiver

iperf Done.
root@ubuntu-test-9qch2:/# 
```

