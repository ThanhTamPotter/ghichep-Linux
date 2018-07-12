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
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
apt-get install rsync -y
add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://ftp.utexas.edu/mariadb/repo/10.1/ubuntu xenial main'
apt-get update -y
apt-get install mariadb-server rsync -y
systemctl stop mysql
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
galera_new_cluster
systemctl start mysql