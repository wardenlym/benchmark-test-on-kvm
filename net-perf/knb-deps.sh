./knb --verbose --client-node worker-01 --server-node worker-02

```
=========================================================
 Benchmark Results
=========================================================
 Name            : knb-1290387
 Date            : 2021-03-18 06:37:24 UTC
 Generator       : knb
 Version         : 1.5.0
 Server          : worker-02
 Client          : worker-01
 UDP Socket size : auto
=========================================================
  Discovered CPU         : Intel Xeon Processor (Skylake, IBRS)
  Discovered Kernel      : 5.4.0-66-generic
  Discovered k8s version : v1.19.7
  Discovered MTU         : 1480
  Idle :
    bandwidth = 0 Mbit/s
    client cpu = total 6.40% (user 3.05%, nice 0.00%, system 3.16%, iowait 0.19%, steal 0.00%)
    server cpu = total 5.88% (user 3.28%, nice 0.00%, system 2.53%, iowait 0.07%, steal 0.00%)
    client ram = 1118 MB
    server ram = 1531 MB
  Pod to pod :
    TCP :
      bandwidth = 2594 Mbit/s
      client cpu = total 12.61% (user 2.31%, nice 0.00%, system 10.13%, iowait 0.17%, steal 0.00%)
      server cpu = total 37.65% (user 3.38%, nice 0.00%, system 34.27%, iowait 0.00%, steal 0.00%)
      client ram = 1123 MB
      server ram = 1531 MB
    UDP :
      bandwidth = 959 Mbit/s
      client cpu = total 29.59% (user 3.21%, nice 0.00%, system 26.38%, iowait 0.00%, steal 0.00%)
      server cpu = total 24.90% (user 5.71%, nice 0.00%, system 19.16%, iowait 0.00%, steal 0.03%)
      client ram = 1121 MB
      server ram = 1532 MB
  Pod to Service :
    TCP :
      bandwidth = 2568 Mbit/s
      client cpu = total 8.98% (user 2.33%, nice 0.00%, system 6.50%, iowait 0.12%, steal 0.03%)
      server cpu = total 22.80% (user 3.36%, nice 0.00%, system 19.39%, iowait 0.05%, steal 0.00%)
      client ram = 1127 MB
      server ram = 1533 MB
    UDP :
      bandwidth = 797 Mbit/s
      client cpu = total 22.56% (user 2.99%, nice 0.00%, system 19.43%, iowait 0.14%, steal 0.00%)
      server cpu = total 17.51% (user 4.39%, nice 0.00%, system 13.09%, iowait 0.03%, steal 0.00%)
      client ram = 1124 MB
      server ram = 1533 MB
=========================================================
```
关闭IP-in-IP encapsulation后 可以达到正常速度
```
=========================================================
 Benchmark Results
=========================================================
 Name            : knb-1368898
 Date            : 2021-03-18 07:56:01 UTC
 Generator       : knb
 Version         : 1.5.0
 Server          : worker-02
 Client          : worker-01
 UDP Socket size : auto
=========================================================
  Discovered CPU         : Intel Xeon Processor (Skylake, IBRS)
  Discovered Kernel      : 5.4.0-66-generic
  Discovered k8s version : v1.19.7
  Discovered MTU         : 1480
  Idle :
    bandwidth = 0 Mbit/s
    client cpu = total 5.00% (user 2.82%, nice 0.00%, system 2.04%, iowait 0.14%, steal 0.00%)
    server cpu = total 4.02% (user 2.23%, nice 0.00%, system 1.77%, iowait 0.02%, steal 0.00%)
    client ram = 1126 MB
    server ram = 1532 MB
  Pod to pod :
    TCP :
      bandwidth = 17271 Mbit/s
      client cpu = total 22.14% (user 2.43%, nice 0.00%, system 19.61%, iowait 0.10%, steal 0.00%)
      server cpu = total 22.81% (user 2.83%, nice 0.00%, system 19.98%, iowait 0.00%, steal 0.00%)
      client ram = 1126 MB
      server ram = 1535 MB
    UDP :
      bandwidth = 1468 Mbit/s
      client cpu = total 30.53% (user 3.88%, nice 0.00%, system 26.56%, iowait 0.09%, steal 0.00%)
      server cpu = total 24.63% (user 6.31%, nice 0.00%, system 18.27%, iowait 0.05%, steal 0.00%)
      client ram = 1126 MB
      server ram = 1535 MB
  Pod to Service :
    TCP :
      bandwidth = 15699 Mbit/s
      client cpu = total 27.71% (user 2.49%, nice 0.00%, system 25.01%, iowait 0.19%, steal 0.02%)
      server cpu = total 22.83% (user 3.32%, nice 0.00%, system 19.48%, iowait 0.00%, steal 0.03%)
      client ram = 1127 MB
      server ram = 1535 MB
    UDP :
      bandwidth = 1038 Mbit/s
      client cpu = total 29.00% (user 3.55%, nice 0.00%, system 25.19%, iowait 0.26%, steal 0.00%)
      server cpu = total 21.83% (user 4.70%, nice 0.00%, system 17.13%, iowait 0.00%, steal 0.00%)
      client ram = 1127 MB
      server ram = 1537 MB
=========================================================
```


node上直接测：
```
root@worker-01:~# iperf3 -s
-----------------------------------------------------------
Server listening on 5201
-----------------------------------------------------------
Accepted connection from 172.29.50.42, port 58286
[  5] local 172.29.50.41 port 5201 connected to 172.29.50.42 port 58288
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec  2.15 GBytes  18.5 Gbits/sec
[  5]   1.00-2.00   sec  2.17 GBytes  18.6 Gbits/sec
[  5]   2.00-3.00   sec  2.10 GBytes  18.0 Gbits/sec
[  5]   3.00-4.00   sec  2.11 GBytes  18.1 Gbits/sec
[  5]   4.00-5.00   sec  2.17 GBytes  18.6 Gbits/sec
[  5]   5.00-6.00   sec  2.19 GBytes  18.8 Gbits/sec
[  5]   6.00-7.00   sec  2.08 GBytes  17.9 Gbits/sec
[  5]   7.00-8.00   sec  2.14 GBytes  18.4 Gbits/sec
[  5]   8.00-9.00   sec  2.18 GBytes  18.7 Gbits/sec
[  5]   9.00-10.00  sec  2.16 GBytes  18.6 Gbits/sec
[  5]  10.00-10.00  sec  1.31 MBytes  9.05 Gbits/sec
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-10.00  sec  21.4 GBytes  18.4 Gbits/sec                  receiver
-----------------------------------------------------------
Server listening on 5201
-----------------------------------------------------------
```