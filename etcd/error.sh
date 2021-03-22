benchmark: /lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.32' not found (required by benchmark)

wget http://mirrors.nju.edu.cn/gnu/libc/glibc-2.32.tar.gz
../configure --prefix=/opt/glibc-2.32
make install
export LD_LIBRARY_PATH=/opt/glibc-2.32/lib:$LD_LIBRARY_PATH
