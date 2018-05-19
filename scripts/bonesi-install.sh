!# /bin/bash

apt update -y && apt upgrade -y
apt install make build-essential libpcap-dev libnet-dev autoconf gcc automake git -y
git clone https://github.com/Markus-Go/bonesi
cd bonesi
automake --add-missing
autoreconf
./configure
automake --add-missing
make
make install

