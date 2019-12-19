#!/bin/bash

#yum update -y
#amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
#yum install -y httpd mariadb-server
#systemctl start httpd
#systemctl enable httpd
#usermod -a -G apache ec2-user
#chown -R ec2-user:apache /var/www
#chmod 2775 /var/www
#find /var/www -type d -exec chmod 2775 {} \;
#find /var/www -type f -exec chmod 0664 {} \;
#echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php


mkdir ~/.aws
touch ~/.aws/config

echo "#########################################"
echo "### USERDATA FOR WORDPRESS - WORDPRESS IAC ###"
echo "#########################################"

# Changing hostname
echo "Changing hostname..."

ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
CURRENT_NAME=$(aws ec2 describe-tags --filters Name=resource-id,Values=$ID Name=key,Values=Name --query Tags[].Value --output text --region {eu-west-1})
ID_TRIM=$(echo $ID | tail -c 5)
NEW_NAME=$CURRENT_NAME-$ID_TRIM
echo "The new name should be $NEW_NAME"
echo "Creating tags..."
aws ec2 create-tags --resources $ID --tags Key=Name,Value=$NEW_NAME --"region eu-west-1"
echo "Updating the running hostname"
hostnamectl set-hostname $HOSTNAME

# Configure nginx 
echo "Configuring nginx site Wordpress
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf-cfinit
aws s3 cp --profile dev-ReadAccessToConfigsBucket s3://application-configurations-tnc58anqy8xkj55g/dev/wordpress/nginx.conf /etc/nginx/

# Configure PHP FPM 7.2
echo "Configuring PHP-FPM 7.2..."
sed -i -e 's/\;php_admin_value\[memory_limit\]\s=\s128M/php_admin_value\[memory_limit\]\ =\ 1024M/g' /etc/php-fpm.d/www.conf
sed -i -e 's/user\s=\sapache/user = nginx/g' /etc/php-fpm.d/www.conf
sed -i -e 's/group\s=\sapache/group = nginx/g' /etc/php-fpm.d/www.conf
sed -i -e 's/;listen.owner\s=\snobody/listen.owner = nginx/g' /etc/php-fpm.d/www.conf
sed -i -e 's/;listen.group\s=\snobody/listen.group = nginx/g' /etc/php-fpm.d/www.conf

# Changing permissions to /var/lib/php
echo "Changing /var/lib/php/* permissions..."
chown nginx:nginx /var/lib/php/* -R
systemctl restart php-fpm