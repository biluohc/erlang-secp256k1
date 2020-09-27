#! /bin/sh

[ -f priv/secp256k1_drv.so ] && exit 0

git clone https://github.com/bitcoin/secp256k1
cd secp256k1
git checkout 0bada0e2a9f8fc3ba0096005d3f0498b70a5c885

make clean
./autogen.sh
./configure CFLAGS=-fPIC
make
./tests

cd ..
rm -rf secp256k1/.libs/libsecp256k1.so*
mkdir -p priv && gcc --shared  -fPIC -o priv/secp256k1_drv.so  c_src/secp256k1.c -lsecp256k1 -Lsecp256k1/.libs/  -I /usr/lib64/erlang/usr/include/ -I secp256k1/include
# cp lib/erlang-secp256k1/priv/secp256k1_drv.so priv/
