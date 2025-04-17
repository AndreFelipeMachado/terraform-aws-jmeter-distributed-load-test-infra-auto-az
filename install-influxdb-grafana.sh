#!/bin/bash
set -e

echo "=== Updating packages ==="
sudo apt update && sudo apt upgrade -y

echo "=== Some basic packages ==="
sudo apt install -y wget curl gnupg2 apt-transport-https software-properties-common unzip  


# ========== InfluxDB 1.x ==========
echo "=== Adding repo for InfluxDB 1.x ==="

# Add old GPG key (InfluxDB 1.x uses legacy key)

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D8FF8E1F7DF8B07E

echo "deb https://repos.influxdata.com/debian stable main" | sudo tee /etc/apt/sources.list.d/influxdb.list

sudo apt update
sudo apt install -y influxdb

echo "=== Enable and start InfluxDB ==="
sudo systemctl enable influxdb
sudo systemctl start influxdb

# Wait for service
sleep 2

# Create our database 'jmeter'
influx -execute 'CREATE DATABASE jmeter'


# ========== Grafana ==========
echo "=== Adding Grafana repository ==="

wget -q -O - https://packages.grafana.com/gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/grafana.gpg
echo "deb [signed-by=/usr/share/keyrings/grafana.gpg] https://packages.grafana.com/oss/deb stable main" | sudo tee /etc/apt/sources.list.d/grafana.list

sudo apt update
sudo apt install -y grafana

echo "=== Enable and start Grafana ==="
sudo systemctl enable grafana-server
sudo systemctl start grafana-server


echo ""
echo "- Grafana:      http://localhost:3000 (login: admin / admin)"
