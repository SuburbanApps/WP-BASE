#!/bin/bash
#1ºinstalacion wordpress
mkdir ~/var/www/efs
cd ~/var/www/efs
sudo wget https://wordpress.org/latest.tar.gz
sudo tar zxf latest.tar.gz
cd wordpress
sudo cp -rpf * ../
cd ../
sudo rm -rf wordpress/ latest.tar.gz

