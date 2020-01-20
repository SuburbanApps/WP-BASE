#!/bin/bash
cd /sites/{{SITE_DOMAIN}}.com/public
sudo wget https://wordpress.org/latest.tar.gz
sudo tar zxf latest.tar.gz
cd wordpress
sudo cp -rpf * ../
cd ../
sudo rm -rf wordpress/ latest.tar.gz

