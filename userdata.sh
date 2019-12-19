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

#!/bin/bash

mkdir ~/.aws
touch ~/.aws/config

echo "#########################################"
echo "### USERDATA FOR WORDPRESS - MYPORTAL ###"
echo "#########################################"

# Changing hostname
echo "Changing hostname..."

ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
CURRENT_NAME=$(aws ec2 describe-tags --filters Name=resource-id,Values=$ID Name=key,Values=Name --query Tags[].Value --output text --region ${aws_region})
ID_TRIM=$(echo $ID | tail -c 5)
NEW_NAME=$CURRENT_NAME-$ID_TRIM
echo "The new name should be $NEW_NAME"
echo "Creating tags..."
aws ec2 create-tags --resources $ID --tags Key=Name,Value=$NEW_NAME --region ${aws_region}
echo "Updating the running hostname"
hostnamectl set-hostname $HOSTNAME

# Configure nginx 
echo "Configuring nginx site Wordpress
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf-cfinit
aws s3 cp --profile ${environment_name}-ReadAccessToConfigsBucket s3://application-configurations-tnc58anqy8xkj55g/${environment_name}/wordpress/nginx.conf /etc/nginx/

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

# WP installation
echo "Getting artifact..."
mkdir /var/www
cd /var/www
aws s3 cp --profile ${environment_name}-ReadAccessToConfigsBucket s3://application-configurations-tnc58anqy8xkj55g/${environment_name}/wordpress/wpbase-latest.tgz .
tar -zxvf wpmyportal-latest.tgz
sed -i "/DB_HOST/s/'[^']*'/'${rds_dnsname}'/2" wp-config.php
sed -i "/DB_NAME/s/'[^']*'/'myportal'/2" wp-config.php
sed -i "/DB_USER/s/'[^']*'/'${rds_user}'/2" wp-config.php
sed -i "/DB_PASSWORD/s/'[^']*'/'${rds_user_password}'/2" wp-config.php
if [ ! -f "/var/www/health-check.php" ]; then
  echo "<?php
\$_SERVER['HTTP_HOST'] = 'myportal.telepizza.com'; // Use the domain of the network root site.
require( './wp-load.php' );
echo 'OK';
?>" >> /var/www/health-check.php
fi
chown root:root /var/www
chown nginx:nginx /var/www/* -R
chmod 755 /var/www/* -R
rm -f wpmyportal-latest.tgz

echo "Installing MariaDB..."
yum install mariadb -y

if [ $(mysql -u root -p${rds_root_password} -h ${rds_dnsname} myportal -sse "SELECT count(*) FROM information_schema.TABLES WHERE (TABLE_SCHEMA = 'myportal') AND (TABLE_NAME = 'tpmf_users');") -gt 0 ]; then
  echo "DB found!!! Skipping DB initialization..."
else
  echo "No tpmf_users table found. Initializing database..."
  cd /tmp
  if [ $(mysql -u root -p${rds_root_password} -h ${rds_dnsname} myportal -sse "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = '${rds_user}');") -gt 0 ]; then
    echo "RDS user ${rds_user} found. Skipping creation"
  else
    echo "RDS user ${rds_user} not found. Creating user..."
    mysql -u root -p${rds_root_password} -h ${rds_dnsname} myportal -sse "CREATE USER '${rds_user}'@'%' IDENTIFIED BY '${rds_user_password}';"
  fi
  echo "Downloading and restoring latest dump..."
  cd /tmp
  aws s3 cp --profile ${environment_name}-ReadAccessToConfigsBucket s3://application-configurations-tnc58anqy8xkj55g/${environment_name}wordpress/wpbase-latest.sql . 
  mysql -u root -p${rds_root_password} -h ${rds_dnsname} myportal < wpbase-latest.sql 
  mysql -u root -p${rds_root_password} -h ${rds_dnsname} myportal -sse "GRANT ALL PRIVILEGES ON myportal.* TO '${rds_user}'@'%';"
  echo "wordpress Dump restored at $( date +'%Y-%m-%d-%H:%M:%S')"
  rm wpbase-latest.sql
fi

# Added cron script for backing up WP code and DB at 18:00
mkdir -p /opt/vectorim/scripts
cat > /opt/vectorim/scripts/backup-myportal.sh << EOF
#!/bin/sh

## WORDPRESS BLOCK
if [ ! -f /var/www/wpmyportal-latest.tgz ]; then
	cd /var/www
	tar zcvf wpmyportal-latest.tgz .
else
	cd /var/www
	rm wpmyportal-latest.tgz -f
	tar zcvf wpmyportal-latest.tgz .
fi

aws s3 cp --profile ${environment_name}-ReadAccessToConfigsBucket wpmyportal-latest.tgz s3://application-configurations-tnc58anqy8xkj55g/${environment_name}/myportal/
rm wpmyportal-latest.tgz -f 

## SQL BLOCK
cd /tmp
mysqldump -u ${rds_user} -p${rds_user_password} -h ${rds_dnsname} myportal > wpmyportal-latest.sql
aws s3 cp --profile ${environment_name}-ReadAccessToConfigsBucket wpmyportal-latest.sql s3://application-configurations-tnc58anqy8xkj55g/${environment_name}/myportal/
rm wpmyportal-latest.sql -f
EOF

chmod ugo+x /opt/vectorim/scripts/backup-myportal.sh
echo "0 17 * * * /opt/vectorim/scripts/backup-wordpress.sh" | crontab -

# Restarting services
echo "Restarting services..."
systemctl restart nginx
systemctl restart php-fpm