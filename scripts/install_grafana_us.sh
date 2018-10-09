#! /bin/bash

echo "deb https://packagecloud.io/grafana/stable/debian/ stretch main" >> /etc/apt/sources.list
curl https://packagecloud.io/gpg.key | sudo apt-key add -
apt-get update -y
apt-get install grafana -y
systemctl daemon-reload
systemctl enable grafana-server.service
systemctl start grafana-server
systemctl status grafana-server