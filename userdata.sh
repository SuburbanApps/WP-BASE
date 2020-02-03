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
mkdir /var/www
sudo tar xf latest-es_ES.tar.gz -C /var/www/html/
cd /var/www