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