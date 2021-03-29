git clone git@github.com:etcd-io/etcd.git
cd etcd && git checkout v3.4.13
cd tools/benchmark && go build

etcdctl member list --cacert=/etc/kubernetes/pki/etcd/ca.crt  --cert=/etc/kubernetes/pki/apiserver-etcd-client.crt --key=/etc/kubernetes/pki/apiserver-etcd-client.key
41958fe47a1c49a9, started, master-02, https://172.29.50.32:2380, https://172.29.50.32:2379, false
62643cad10e265ce, started, master-03, https://172.29.50.33:2380, https://172.29.50.33:2379, false
98c071c0aa6d85f9, started, master-01, https://172.29.50.31:2380, https://172.29.50.31:2379, false

#查看leader
etcdctl --write-out=table member list --cacert=/etc/kubernetes/pki/etcd/ca.crt  --cert=/etc/kubernetes/pki/apiserver-etcd-client.crt --key=/etc/kubernetes/pki/apiserver-etcd-client.key

etcdctl --write-out=table  endpoint status --cacert=/etc/kubernetes/pki/etcd/ca.crt  --cert=/etc/kubernetes/pki/apiserver-etcd-client.crt --key=/etc/kubernetes/pki/apiserver-etcd-client.key

# 测试leader节点
benchmark --endpoints="https://172.29.50.32:2379" --target-leader --conns=1 --clients=1 put --key-size=8 --sequential-keys --total=10000 --val-size=256 --cacert=/etc/kubernetes/pki/etcd/ca.crt  --cert=/etc/kubernetes/pki/apiserver-etcd-client.crt --key=/etc/kubernetes/pki/apiserver-etcd-client.key

写入测试
```
# --conns=1 --clients=1 --total=10000
benchmark --endpoints="https://172.29.50.32:2379" --target-leader --conns=1 --clients=1 put --key-size=8 --sequential-keys --total=10000 --val-size=256 --cacert=/etc/kubernetes/pki/etcd/ca.crt  --cert=/etc/kubernetes/pki/apiserver-etcd-client.crt --key=/etc/kubernetes/pki/apiserver-etcd-client.key

INFO: 2021/03/22 10:31:17 [core] Channel Connectivity change to CONNECTING
INFO: 2021/03/22 10:31:17 [core] Subchannel picks a new address "172.29.50.32:2379" to connect
 0 / 10000 B                                                                                                                                  !   0.00%INFO: 2021/03/22 10:31:17 [core] Subchannel Connectivity change to READY
INFO: 2021/03/22 10:31:17 [roundrobin] roundrobinPicker: newPicker called with info: {map[0xc0001d2d10:{{172.29.50.32:2379 172.29.50.32 <nil> 0 <nil>}}]}
INFO: 2021/03/22 10:31:17 [core] Channel Connectivity change to READY
 10000 / 10000 Boooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo! 100.00% 22s

Summary:
  Total:        22.3068 secs.
  Slowest:      0.0259 secs.
  Fastest:      0.0012 secs.
  Average:      0.0022 secs.
  Stddev:       0.0008 secs.
  Requests/sec: 448.2936

Response time histogram:
  0.0012 [1]    |
  0.0036 [9616] |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  0.0061 [331]  |∎
  0.0086 [33]   |
  0.0111 [12]   |
  0.0135 [4]    |
  0.0160 [1]    |
  0.0185 [0]    |
  0.0210 [0]    |
  0.0235 [1]    |
  0.0259 [1]    |

Latency distribution:
  10% in 0.0016 secs.
  25% in 0.0018 secs.
  50% in 0.0021 secs.
  75% in 0.0024 secs.
  90% in 0.0030 secs.
  95% in 0.0034 secs.
  99% in 0.0051 secs.
  99.9% in 0.0105 secs.
```

```
# --conns=100 --clients=1000 --total=100000
benchmark --endpoints="https://172.29.50.32:2379" --target-leader --conns=100 --clients=1000 put --key-size=8 --sequential-keys --total=100000 --val-size=256 --cacert=/etc/kubernetes/pki/etcd/ca.crt  --cert=/etc/kubernetes/pki/apiserver-etcd-client.crt --key=/etc/kubernetes/pki/apiserver-etcd-client.key


INFO: 2021/03/22 10:34:45 [core] Channel Connectivity change to READY
 100000 / 100000 Booooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo! 100.00% 9s

Summary:
  Total:        9.0551 secs.
  Slowest:      0.2736 secs.
  Fastest:      0.0070 secs.
  Average:      0.0899 secs.
  Stddev:       0.0292 secs.
  Requests/sec: 11043.4789

Response time histogram:
  0.0070 [1]    |
  0.0336 [1197] |∎
  0.0603 [13497]        |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  0.0870 [33586]        |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  0.1136 [33796]        |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  0.1403 [12250]        |∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  0.1669 [4278] |∎∎∎∎∎
  0.1936 [942]  |∎
  0.2202 [296]  |
  0.2469 [154]  |
  0.2736 [3]    |

Latency distribution:
  10% in 0.0554 secs.
  25% in 0.0697 secs.
  50% in 0.0880 secs.
  75% in 0.1059 secs.
  90% in 0.1261 secs.
  95% in 0.1431 secs.
  99% in 0.1725 secs.
  99.9% in 0.2251 secs.


```

所有 members

```
benchmark --endpoints="https://172.29.50.31:2379,https://172.29.50.32:2379,https://172.29.50.33:2379" --conns=1 --clients=1 put --key-size=8 --sequential-keys --total=10000 --val-size=256 --cacert=/etc/kubernetes/pki/etcd/ca.crt  --cert=/etc/kubernetes/pki/apiserver-etcd-client.crt --key=/etc/kubernetes/pki/apiserver-etcd-client.key
INFO: 2021/03/22 10:38:59 [core] Channel Connectivity change to READY
 10000 / 10000 Boooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo! 100.00% 31s

Summary:
  Total:        31.2222 secs.
  Slowest:      0.0454 secs.
  Fastest:      0.0016 secs.
  Average:      0.0031 secs.
  Stddev:       0.0013 secs.
  Requests/sec: 320.2854

Response time histogram:
  0.0016 [1]    |
  0.0060 [9723] |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  0.0104 [236]  |
  0.0148 [30]   |
  0.0191 [8]    |
  0.0235 [0]    |
  0.0279 [0]    |
  0.0323 [0]    |
  0.0367 [0]    |
  0.0411 [1]    |
  0.0454 [1]    |
   10000 / 10000 Boooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo! 100.00% 30s

Summary:
  Total:        30.3524 secs.
  Slowest:      0.0531 secs.
  Fastest:      0.0015 secs.
  Average:      0.0030 secs.
  Stddev:       0.0012 secs.
  Requests/sec: 329.4636

Response time histogram:
  0.0015 [1]    |
  0.0067 [9850] |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  0.0119 [134]  |
  0.0170 [14]   |
  0.0222 [0]    |
  0.0273 [0]    |
  0.0325 [0]    |
  0.0376 [0]    |
  0.0428 [0]    |
  0.0479 [0]    |
  0.0531 [1]    |

Latency distribution:
  10% in 0.0021 secs.
  25% in 0.0024 secs.
  50% in 0.0028 secs.
  75% in 0.0033 secs.
  90% in 0.0041 secs.
  95% in 0.0048 secs.
  99% in 0.0077 secs.
  99.9% in 0.0131 secs.
```

```

benchmark --endpoints="https://172.29.50.31:2379,https://172.29.50.32:2379,https://172.29.50.33:2379" --conns=100 --clients=1000 put --key-size=8 --sequential-keys --total=100000 --val-size=256 --cacert=/etc/kubernetes/pki/etcd/ca.crt  --cert=/etc/kubernetes/pki/apiserver-etcd-client.crt --key=/etc/kubernetes/pki/apiserver-etcd-client.key
Summary:
  Total:        5.5593 secs.
  Slowest:      0.1659 secs.
  Fastest:      0.0051 secs.
  Average:      0.0538 secs.
  Stddev:       0.0233 secs.
  Requests/sec: 17987.7284

Response time histogram:
  0.0051 [1]    |
  0.0212 [1839] |∎∎
  0.0373 [24930]        |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  0.0533 [31205]        |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  0.0694 [19634]        |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  0.0855 [11863]        |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  0.1016 [6630] |∎∎∎∎∎∎∎∎
  0.1177 [2155] |∎∎
  0.1337 [1037] |∎
  0.1498 [606]  |
  0.1659 [100]  |

Latency distribution:
  10% in 0.0289 secs.
  25% in 0.0364 secs.
  50% in 0.0487 secs.
  75% in 0.0668 secs.
  90% in 0.0863 secs.
  95% in 0.0974 secs.
  99% in 0.1279 secs.
  99.9% in 0.1499 secs.
```

读取

$ benchmark --endpoints="https://172.29.50.31:2379,https://172.29.50.32:2379,https://172.29.50.33:2379"  --conns=1 --clients=1  range foo --consistency=l --total=10000 --cacert=/etc/kubernetes/pki/etcd/ca.crt  --cert=/etc/kubernetes/pki/apiserver-etcd-client.crt --key=/etc/kubernetes/pki/apiserver-etcd-client.key
```
 10000 / 10000 Boooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo! 100.00% 13s

Summary:
  Total:        13.5678 secs.
  Slowest:      0.0218 secs.
  Fastest:      0.0006 secs.
  Average:      0.0014 secs.
  Stddev:       0.0008 secs.
  Requests/sec: 737.0410

Response time histogram:
  0.0006 [1]    |
  0.0027 [9685] |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  0.0048 [191]  |
  0.0070 [79]   |
  0.0091 [27]   |
  0.0112 [13]   |
  0.0133 [3]    |
  0.0154 [0]    |
  0.0176 [0]    |
  0.0197 [0]    |
  0.0218 [1]    |

Latency distribution:
  10% in 0.0009 secs.
  25% in 0.0010 secs.
  50% in 0.0012 secs.
  75% in 0.0014 secs.
  90% in 0.0018 secs.
  95% in 0.0023 secs.
  99% in 0.0053 secs.
  99.9% in 0.0103 secs.
```

$ benchmark --endpoints="https://172.29.50.31:2379,https://172.29.50.32:2379,https://172.29.50.33:2379"  --conns=1 --clients=1  range foo --consistency=s --total=10000 --cacert=/etc/kubernetes/pki/etcd/ca.crt  --cert=/etc/kubernetes/pki/apiserver-etcd-client.crt --key=/etc/kubernetes/pki/apiserver-etcd-client.key
```
INFO: 2021/03/22 10:45:46 [core] Channel Connectivity change to READY
 10000 / 10000 Booooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo! 100.00% 4s

Summary:
  Total:        4.4582 secs.
  Slowest:      0.0149 secs.
  Fastest:      0.0002 secs.
  Average:      0.0004 secs.
  Stddev:       0.0005 secs.
  Requests/sec: 2243.0420

Response time histogram:
  0.0002 [1]    |
  0.0016 [9875] |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  0.0031 [49]   |
  0.0046 [33]   |
  0.0060 [20]   |
  0.0075 [8]    |
  0.0090 [9]    |
  0.0104 [3]    |
  0.0119 [1]    |
  0.0134 [0]    |
  0.0149 [1]    |

Latency distribution:
  10% in 0.0003 secs.
  25% in 0.0003 secs.
  50% in 0.0004 secs.
  75% in 0.0005 secs.
  90% in 0.0006 secs.
  95% in 0.0007 secs.
  99% in 0.0023 secs.
  99.9% in 0.0082 secs.
```
$ benchmark --endpoints="https://172.29.50.31:2379,https://172.29.50.32:2379,https://172.29.50.33:2379"  --conns=100 --clients=1000  range foo --consistency=l --total=100000 --cacert=/etc/kubernetes/pki/etcd/ca.crt  --cert=/etc/kubernetes/pki/apiserver-etcd-client.crt --key=/etc/kubernetes/pki/apiserver-etcd-client.key
```
INFO: 2021/03/22 10:46:12 [core] Channel Connectivity change to READY
 100000 / 100000 Booooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo! 100.00% 4s

Summary:
  Total:        4.7671 secs.
  Slowest:      0.1982 secs.
  Fastest:      0.0010 secs.
  Average:      0.0452 secs.
  Stddev:       0.0255 secs.
  Requests/sec: 20977.1400

Response time histogram:
  0.0010 [1]    |
  0.0207 [15765]        |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  0.0404 [34064]        |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  0.0601 [26236]        |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  0.0799 [14038]        |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  0.0996 [6425] |∎∎∎∎∎∎∎
  0.1193 [2111] |∎∎
  0.1390 [787]  |
  0.1587 [411]  |
  0.1784 [148]  |
  0.1982 [14]   |

Latency distribution:
  10% in 0.0171 secs.
  25% in 0.0261 secs.
  50% in 0.0405 secs.
  75% in 0.0589 secs.
  90% in 0.0797 secs.
  95% in 0.0926 secs.
  99% in 0.1262 secs.
  99.9% in 0.1648 secs.
```
$ benchmark --endpoints="https://172.29.50.31:2379,https://172.29.50.32:2379,https://172.29.50.33:2379"  --conns=100 --clients=1000  range foo --consistency=s --total=100000 --cacert=/etc/kubernetes/pki/etcd/ca.crt  --cert=/etc/kubernetes/pki/apiserver-etcd-client.crt --key=/etc/kubernetes/pki/apiserver-etcd-client.key
```
 100000 / 100000 Booooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo! 100.00% 3s

Summary:
  Total:        3.3070 secs.
  Slowest:      0.2910 secs.
  Fastest:      0.0003 secs.
  Average:      0.0298 secs.
  Stddev:       0.0246 secs.
  Requests/sec: 30238.5352

Response time histogram:
  0.0003 [1]    |
  0.0293 [61081]        |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  0.0584 [28832]        |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  0.0875 [6850] |∎∎∎∎
  0.1166 [2010] |∎
  0.1456 [713]  |
  0.1747 [341]  |
  0.2038 [82]   |
  0.2329 [71]   |
  0.2620 [1]    |
  0.2910 [18]   |

Latency distribution:
  10% in 0.0077 secs.
  25% in 0.0130 secs.
  50% in 0.0237 secs.
  75% in 0.0384 secs.
  90% in 0.0587 secs.
  95% in 0.0773 secs.
  99% in 0.1241 secs.
  99.9% in 0.1938 secs.
```

