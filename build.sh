#!/bin/sh

echo 'Prepare GCC Toolchain'

sudo apt-get install -qy gcc-aarch64-linux-gnu gcc-arm-linux-gnueabihf g++-aarch64-linux-gnu g++-arm-linux-gnueabihf
rustup target add aarch64-unknown-linux-gnu
sudo dpkg --add-architecture arm64
sudo cp build/ubuntu-multi-arch.sources /etc/apt/sources.list.d/ubuntu-multi-arch.sources
sudo apt-get update -qy
sudo apt-get install -qy libssl-dev:arm64

echo 'Patch ZeroTier for Cross-Compile'
sudo apt install -qy python3-pip python3-toml
python3 build/patch.py

echo 'Build for aarch64'
CC=aarch64-linux-gnu-gcc
CXX=aarch64-linux-gnu-g++

cd ZeroTierOne
cp make-linux.mk.aarch64 make-linux.mk
make clean
make --silent -w -j $(nproc) ZT_SSO_SUPPORTED=0 ZT_STATIC=1 ZT_DEBUG=0 CC=$CC CXX=$CXX LDFLAGS="-s"
cd ..

cp ZeroTierOne/zerotier-one magisk/zerotier
