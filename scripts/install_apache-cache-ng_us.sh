#! /bin/bash
apt-get install apt-cacher-ng -y
sed -i 's/# Port:3142/Port:3142/g' /etc/apt-cacher-ng/acng.conf
sed -i 's/# PidFile/PidFile/g' /etc/apt-cacher-ng/acng.conf
echo BindAddress: 0.0.0.0 > /etc/apt-cacher-ng/acng.conf
/etc/init.d/apt-cacher-ng restart