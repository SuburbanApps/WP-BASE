#!/bin/bash
#CREAR PUNTO DE MONTAJE

echo "Creando NFS"
sudo yum -y install nfs-utils
sudo mkdir efs
sudo mount -t efs fs-89400a42:/ efs
sudo mount -t efs -o tls fs-89400a42:/ efs
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-89400a42.efs.eu-west-1.amazonaws.com:/ efs
cd /efs
ls -al
sudo chmod go+rw .
sudo touch test-file.txt

#INSTALAR WORDPRESS
# WP installation
echo "Instalando Wordpress"
mkdir /var/www/html
wget https://es.wordpress.org/latest-es_ES.tar.gz
sudo tar xf latest-es_ES.tar.gz -C /var/www/html/
sed -i "/DB_HOST/s/'[^']*'/'${rds_dnsname}'/2" wp-config.php
sed -i "/DB_NAME/s/'[^']*'/'dbwp'/2" wp-config.php
sed -i "/DB_USER/s/'[^']*'/'root'/2" wp-config.php
sed -i "/DB_PASSWORD/s/'[^']*'/'12345678'/2" wp-config.php
if [ ! -f "/var/www/health-check.php" ]; then
  echo "<?php
\$_SERVER['HTTP_HOST'] = 'ec2-user@172.31.53.77'; // Use the domain of the network root site.
require( './wp-load.php' );
echo 'OK';
?>" >> /var/www/health-check.php
fi
chown root:root /var/www
chown nginx:nginx /var/www/* -R
chmod 755 /var/www/* -R
rm -f wpmyportal-latest.tgz
