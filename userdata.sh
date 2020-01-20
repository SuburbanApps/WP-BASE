#!/bin/bash
#1ºinstalacion wordpress
#cloud-config
package_upgrade: true
packages:
nfs-utils
httpd
php
runcmd:
echo "$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone).fs-657731ae.efs.eu-west-1.amazonaws.com.efs.us-west-2.amazonaws.com:/    /var/www/html/efs   nfs4    defaults" >> /etc/fstab
mkdir /var/www/html/efs
mount -a
service httpd start
chkconfig httpd on

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
