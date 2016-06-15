#!/bin/bash
#./build-avconv.sh
cd /root
tar -xvzf libav-10.1.tar.gz
cd libav-10.1
./configure --extra-cflags=-I/opt/local/include --extra-ldflags=-L/opt/local/lib --enable-gpl --enable-version3  --enable-libvpx
make
make install
ln -s /usr/local/bin/avconv /usr/bin/avconv