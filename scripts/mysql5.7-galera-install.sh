#! /bin/bash
ip_node1=10.10.10.11
ip_node2=10.10.10.12
ip_node3=10.10.10.13
host1=db1
host2=db2
host3=db2
ln -s /etc/apparmor.d/usr /etc/apparmor.d/disable/.sbin.mysqld
systemctl restart apparmor
apt-get update -y
apt-get install software-properties-common -y
apt-key adv --keyserver keyserver.ubuntu.com --recv BC19DDBA
apt-get install rsync -y
cat << EOF > /etc/apt/sources.list.d/galera.list
deb http://releases.galeracluster.com/mysql-wsrep-5.7/ubuntu xenial main 
deb http://releases.galeracluster.com/galera-3/ubuntu xenial main
EOF
cat << EOF > /etc/apt/preferences.d/galera.pref
# Prefer Codership repository
Package: *
Pin: origin releases.galeracluster.com
Pin-Priority: 1001
EOF
apt-get update -y
apt-get install galera-3 galera-arbitrator-3 mysql-wsrep-5.7 -y

cat << EOF > /etc/mysql/conf.d/galera.cnf
[mysqld]
binlog_format=ROW
default-storage-engine=innodb
innodb_autoinc_lock_mode=2
bind-address=0.0.0.0
# Galera Provider Configuration
wsrep_on=ON
wsrep_provider=/usr/lib/galera/libgalera_smm.so

# Galera Cluster Configuration
wsrep_cluster_name="test_cluster"
wsrep_cluster_address="gcomm://$ip_node1,$ip_node2,$ip_node3"
# Galera Synchronization Configuration
wsrep_sst_method=rsync

# Galera Node Configuration
wsrep_node_address="$ip_node1"
wsrep_node_name="$host1"
EOF
systemctl start mysql
/usr/bin/mysqld_bootstrap

