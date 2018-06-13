IF_NAME=ens5
MYSQL_PASS=1
SNORT_DB_PASS=1
NETMASK=10.10.20.0/24

echo "### Install Snort ###"
sleep 3
apt-get update -y
ethtool -K $IF_NAME gro off
echo "post-up ethtool -K $IF_NAME gro off" >> /etc/network/interfaces
apt-get install -y build-essential
apt-get install libpcap-dev libpcre3-dev libdumbnet-dev bison flex -y 
apt-get install bison flex -y
mkdir ~/snort_src
cd ~/snort_src
wget https://snort.org/downloads/snort/daq-2.0.6.tar.gz
tar -xvzf daq-2.0.6.tar.gz
cd daq-2.0.6
./configure
make
make install
apt-get install zlib1g-dev liblzma-dev openssl libssl-dev -y
apt-get install libnghttp2-dev -y
cd ~/snort_src
wget https://snort.org/downloads/snort/snort-2.9.11.1.tar.gz
tar -xvzf snort-2.9.11.1.tar.gz
cd snort-2.9.11.1
./configure --enable-sourcefire
make
make install
ldconfig
ln -s /usr/local/bin/snort /usr/sbin/snort
groupadd snort
useradd snort -r -s /sbin/nologin -c SNORT_IDS -g snort
mkdir /etc/snort
mkdir /etc/snort/rules
mkdir /etc/snort/rules/iplists
mkdir /etc/snort/preproc_rules
mkdir /usr/local/lib/snort_dynamicrules
mkdir /etc/snort/so_rules
touch /etc/snort/rules/iplists/black_list.rules
touch /etc/snort/rules/iplists/white_list.rules
touch /etc/snort/rules/local.rules
touch /etc/snort/sid-msg.map
mkdir /var/log/snort
mkdir /var/log/snort/archived_logs
chown -R snort:snort /etc/snort
chown -R snort:snort /var/log/snort
chown -R snort:snort /usr/local/lib/snort_dynamicrules
cd etc/
cp *.conf* /etc/snort
cp *.map /etc/snort
cp *.dtd /etc/snort
cd ~/snort_src/snort-2.9.11.1/src/dynamic-preprocessors/build/usr/local/lib/snort_dynamicpreprocessor/
cp * /usr/local/lib/snort_dynamicpreprocessor/
cp /etc/snort/snort.conf /etc/snort/snort.conf.orig
sed -i "s/include \$RULE\_PATH/#include \$RULE\_PATH/" /etc/snort/snort.conf
sed -i "s|ipvar HOME_NET.*|ipvar HOME_NET $NETMASK|g" /etc/snort/snort.conf
sed -i 's/var RULE_PATH.*/var RULE_PATH \/etc\/snort\/rules/g' /etc/snort/snort.conf
sed -i 's/var SO_RULE_PATH.*/var SO_RULE_PATH \/etc\/snort\/so_rules/g' /etc/snort/snort.conf
sed -i 's/var PREPROC_RULE_PATH.*/var PREPROC_RULE_PATH \/etc\/snort\/preproc_rules/g' /etc/snort/snort.conf
sed -i 's/var WHITE_LIST_PATH.*/var WHITE_LIST_PATH \/etc\/snort\/rules\/iplists/g' /etc/snort/snort.conf
sed -i 's/var BLACK_LIST_PATH.*/var BLACK_LIST_PATH \/etc\/snort\/rules\/iplists/g' /etc/snort/snort.conf
sed -i 's/#include \$RULE\_PATH\/local\.rules/include \$RULE\_PATH\/local\.rules/g' /etc/snort/snort.conf
echo "alert icmp any any -> \$HOME_NET any (msg:"ICMP test detected"; GID:1; sid:10000001; rev:001; classtype:icmp-event;)" > /etc/snort/rules/local.rules
echo "#v2
1 || 10000001 || 001 || icmp-event || 0 || ICMP Test detected || url,tools.ietf.org/html/rfc792" /etc/snort/sid-msg.map




echo "### Install Barnyard ###"
sleep 3
apt-get install debconf-utils -y
debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_PASS"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_PASS"
apt-get install mysql-server libmysqlclient-dev mysql-client autoconf libtool  -y
sed -i '522s/.*/output unified2: filename snort.u2, limit 128/g' /etc/snort/snort.conf
cd ~/snort_src
wget https://github.com/firnsy/barnyard2/archive/master.tar.gz -O barnyard2-Master.tar.gz
tar zxvf barnyard2-Master.tar.gz
cd barnyard2-master/
autoreconf -fvi -I ./m4
ln -s /usr/include/dumbnet.h /usr/include/dnet.h
ldconfig
./configure --with-mysql --with-mysql-libraries=/usr/lib/x86_64-linux-gnu
make
make install
cp ~/snort_src/barnyard2-master/etc/barnyard2.conf /etc/snort/
mkdir /var/log/barnyard2
chown snort.snort /var/log/barnyard2
touch /var/log/snort/barnyard2.waldo
chown snort.snort /var/log/snort/barnyard2.waldo 
cat << EOF | mysql -u root -p$MYSQL_PASS
create database snort;
use snort;
source ~/snort_src/barnyard2-master/schemas/create_mysql
CREATE USER 'snort'@'localhost' IDENTIFIED BY '$SNORT_DB_PASS';
grant create, insert, select, delete, update on snort.* to 'snort'@'localhost';
exit
EOF
echo "output database: log, mysql, user=snort password=$SNORT_DB_PASS dbname=snort host=localhost sensor name=sensor01" >> /etc/snort/barnyard2.conf
chmod o-r /etc/snort/barnyard2.conf
# barnyard2 -c /etc/snort/barnyard2.conf -d /var/log/snort -f snort.u2 -w /var/log/snort/barnyard2.waldo -g snort -u snort

echo "### Install Pulledpork ###"
sleep 3
apt-get install libcrypt-ssleay-perl liblwp-useragent-determined-perl -y
cd ~/snort_src
wget https://github.com/shirkdog/pulledpork/archive/master.tar.gz -O pulledpork-master.tar.gz
tar xzvf pulledpork-master.tar.gz
cd pulledpork-master/
cp pulledpork.pl /usr/local/bin
chmod +x /usr/local/bin/pulledpork.pl
cp etc/*.conf /etc/snort
sed -i '19s/<oinkcode>/b09120ff9f3a7747a6491c27389eddc6dae99db9/g' /etc/snort/pulledpork.conf
sed -i '29s/#rule/rule/g' /etc/snort/pulledpork.conf
sed -i '74s/\/usr\/local//g' /etc/snort/pulledpork.conf
sed -i '89s/\/usr\/local//g' /etc/snort/pulledpork.conf
sed -i '92s/\/usr\/local//g' /etc/snort/pulledpork.conf
sed -i '96s/1/2/g' /etc/snort/pulledpork.conf
sed -i '119s/\/usr\/local//g' /etc/snort/pulledpork.conf
sed -i 's/distro=.*/distro=Ubuntu-16-04/g' /etc/snort/pulledpork.conf
sed -i '141s/\/usr\/local//g' /etc/snort/pulledpork.conf
sed -i '150s/\/usr\/local//g' /etc/snort/pulledpork.conf
/usr/local/bin/pulledpork.pl -c /etc/snort/pulledpork.conf -l

sed -i '547s/.*/include \$RULE_PATH\/snort.rules/g' /etc/snort/snort.conf

cat << EOF > /lib/systemd/system/snort.service
[Unit]
Description=Snort NIDS Daemon
After=syslog.target network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/snort -q -u snort -g snort -c /etc/snort/snort.conf -i ens3

[Install]
WantedBy=multi-user.target
EOF
chmod +x /lib/systemd/system/snort.service
systemctl enable snort
systemctl start snort
cat << EOF > /lib/systemd/system/barnyard2.service
[Unit]
Description=Barnyard2 Daemon
After=syslog.target network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/barnyard2 -c /etc/snort/barnyard2.conf -d /var/log/snort -f snort.u2 -q -w /var/log/snort/barnyard2.waldo -g snort -u snort -D -a /var/log/snort/archived_logs

[Install]
WantedBy=multi-user.target
EOF
systemctl enable barnyard2
systemctl start barnyard2


### Install BASE: phan nay chua hoan thien
apt install software-properties-common -y
yes "" | add-apt-repository ppa:ondrej/php
apt-get update -y
apt-get install apache2 libapache2-mod-php5.6 php5.6-mysql php5.6-cli php5.6 php5.6-common php5.6-gd php5.6-cli php-pear php5.6-xml -y
pear install -f --alldeps Image_Graph
cd ~/snort_src
wget https://sourceforge.net/projects/adodb/files/adodb-php5-only/adodb-520-for-php5/adodb-5.20.8.tar.gz
tar -xvzf adodb-5.20.8.tar.gz
mv adodb5 /var/adodb
chmod -R 755 /var/adodb
cd ~/snort_src
wget http://sourceforge.net/projects/secureideas/files/BASE/base-1.4.5/base-1.4.5.tar.gz
tar xzvf base-1.4.5.tar.gz
mv base-1.4.5 /var/www/html/base/

cd /var/www/html/base
cp base_conf.php.dist base_conf.php
sed -i "s/BASE_urlpath.*/BASE_urlpath = \'base\';/g" base_conf.php
sed -i "s/DBlib_path.*/DBlib_path = \'\/var\/adodb\/\';/g" base_conf.php
sed -i "s/alert_dbname   =.*/alert_dbname   = \'snort\';/g" base_conf.php
sed -i "s/alert_password =.*/alert_password = \'$SNORT_DB_PASS\';/g" base_conf.php

chown -R www-data:www-data /var/www/html/base
chmod o-r /var/www/html/base/base_conf.php
service apache2 restart
echo "### Check in http://IP_Snort_Server/base/index.php ###"
 
echo "## check snort version ##"
snort -V
echo "## check barnyard version ##"
/usr/local/bin/barnyard2 -V
echo "## check pulledpork version ##"
/usr/local/bin/pulledpork.pl -V

 