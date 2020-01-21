#!/bin/bash

mkdir ~/.aws
touch ~/.aws/config
cd ~/var/www/efs
sudo wget https://wordpress.org/latest.tar.gz
sudo tar zxf latest.tar.gz
cd wordpress
sudo cp -rpf * ../
cd ../
sudo rm -rf wordpress/ latest.tar.gz
    