#!bin/bash

echo "Updates"
sudo apt-get update -y && sudo apt-get upgrade -y

echo "Alien Installation"
sudo apt install alien -y
alien -V

echo "rpm download and install"
sudo apt install openjdk-17-jdk -y
JAVA_HOME="/usr/lib/jvm/openjdk-17/"
source /etc/environment
echo $JAVA_HOME

echo "unzip install"
sudo apt install unzip -y

echo "Download Jira Core 9.12.4"
wget https://product-downloads.atlassian.com/software/jira/downloads/atlassian-jira-core-9.12.4.zip -P ./

echo "unzipping"
unzip ./atlassian-jira-core-9.12.4.zip

echo "-------------Set Home Directory fo Jira"
sed '2i\ export JIRA_HOME=/var/atlassian/application-data/jira/' >> ./atlassian-jira-core-9.12.2-standalone/bin/start-jira.sh
echo "Start"

echo "Copy Jira config"
sudo cp ./server.xml ./atlassian-jira-core-9.12.2-standalone/conf/server.xml

echo "Start Jira"
sudo bash ./atlassian-jira-core-9.12.2-standalone/bin/start-jira.sh

echo "Install HAproxy"
sudo add-apt-repository ppa:vbernat/haproxy-2.6 -y && sudo apt update
&& sudo apt install -y haproxy=2.6.\*

echo "Check HAProxy version"
haproxy -v

echo "Copy HAProxy config to /etc"
cp ./haproxy.cfg /etc/haproxy/haproxy.cfg

echo "HAproxy Service Start and Enable"
systemctl start haproxy.service && systemctl enable haproxy.service

echo "HAproxy Status"
systemctl status haproxy.service

echo "Install Docker"
echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" |   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
docker --version

echo "Move to Directory and Build Docker Container  "
cd ./dbdocker/ && docker build ./ --tag postgree:10.5_alpine
echo delay 30s

echo "Run Docker"
cd ./dbdocker/
docker run -d -p 5432:5432 postgree:10.5_alpine

echo "Docker Stats"
docker ps
