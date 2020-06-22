#! /bin/bash
## script backup incremental mySQL 8 run on container hourly, full backup at 01h00 daily
new=$(date +%y%m%d_%H)h00
old=$(date -d "-1 hour" +%y%m%d_%H)h00
if [[ $new =~ "01h00" ]]; then 
new=$new-full
mkdir -p /opt/backup-mysqlCW/$new
echo "###########################################################" >> /var/log/backup_mysqlCW.log
echo "Created FULL BACKUP database at $(date +%y%m%d_%H%M) in folder /opt/backup-mysqlCW/$new" >> /var/log/backup_mysqlCW.log
docker run --rm -i -v /opt/mysql-CW:/var/lib/mysql -v /opt/backup-mysqlCW/$new:/xtrabackup_backupfiles perconalab/percona-xtrabackup:8.0 xtrabackup --backup --host=<ip_mysql_container> --user=<dbuser> --password=<dbuser_password> --port 3306 >> /var/log/backup_mysqlCW.log
find /opt/backup-mysqlCW/* -type d -ctime +2 -exec rm -rf {} \;
else  
if [[ $new =~ "02h00" ]]; then old=$old-full ; fi 
mkdir -p /opt/backup-mysqlCW/$new
echo "Created incremental hourly backup database at $(date +%y%m%d_%H%M) in folder /opt/backup-mysqlCW/$new" >> /var/log/backup_mysqlCW.log
docker run --rm -i -v /opt/mysql-CW:/var/lib/mysql -v /opt/backup-mysqlCW/$old:/tmp  -v /opt/backup-mysqlCW/$new:/xtrabackup_backupfiles perconalab/percona-xtrabackup:8.0 xtrabackup --backup --incremental-basedir=/tmp --host=<ip_mysql_container> --user=<dbuser> --password=<dbuser_password> --port 3306 >> /var/log/backup_mysqlCW.log
fi
echo "  " >> /var/log/backup_mysqlCW.log
