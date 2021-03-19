服务端： qperf
客户端： qperf 10.44.171.47 -oo msg_size:1:64K:*2 -vu tcp_lat
延迟测试：
```
root@ubuntu-test-9qch2:/# qperf 10.44.171.47 -oo msg_size:1:64K:*2 -vu tcp_lat
tcp_lat:
    latency   =  50.9 us
    msg_size  =     1 bytes
tcp_lat:
    latency   =  51.9 us
    msg_size  =     2 bytes
tcp_lat:
    latency   =  50.4 us
    msg_size  =     4 bytes
tcp_lat:
    latency   =  50.9 us
    msg_size  =     8 bytes
tcp_lat:
    latency   =  51.3 us
    msg_size  =    16 bytes
tcp_lat:
    latency   =  50.3 us
    msg_size  =    32 bytes
tcp_lat:
    latency   =  49.1 us
    msg_size  =    64 bytes
tcp_lat:
    latency   =   52 us
    msg_size  =  128 bytes
tcp_lat:
    latency   =  52.2 us
    msg_size  =   256 bytes
tcp_lat:
    latency   =  53.9 us
    msg_size  =   512 bytes
tcp_lat:
    latency   =  52.5 us
    msg_size  =     1 KiB (1,024)
tcp_lat:
    latency   =  48.5 us
    msg_size  =     2 KiB (2,048)
tcp_lat:
    latency   =  52.2 us
    msg_size  =     4 KiB (4,096)
tcp_lat:
    latency   =  55.6 us
    msg_size  =     8 KiB (8,192)
tcp_lat:
    latency   =  60 us
    msg_size  =  16 KiB (16,384)
tcp_lat:
    latency   =  80 us
    msg_size  =  32 KiB (32,768)
tcp_lat:
    latency   =  104 us
    msg_size  =   64 KiB (65,536)
```