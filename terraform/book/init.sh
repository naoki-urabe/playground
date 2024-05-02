#!/bin/bash
sudo apt update
sudo apt install -y apache2 mariadb-server php php-mbstring php-mysql
sudo service apache2 start
cd /home/ubuntu
wget https://nodejs.org/dist/v18.16.1/node-v18.16.1-linux-x64.tar.xz
tar Jxfv node-v18.16.1-linux-x64.tar.xz
sudo mv /home/ubuntu/node-v18.16.1-linux-x64/bin /usr/local