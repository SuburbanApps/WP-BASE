#!/bin/bash
#CREAR PUNTO DE MONTAJE

echo "Creando NFS"
sudo yum -y update  
sudo reboot
sudo yum-config-manager --enable epel
sudo yum -y install nfs-utils
sudo mkdir /mnt/efs
sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport xxxxxxx:/  /mnt/efs  
#ec2-xx-xxx-xxx-xx.aws-region.compute.amazonaws.com #dns EC2
#file-system-id.efs.aws-region.amazonaws.com #dns file system
cd /mnt/efs
ls -al
sudo chmod go+rw .
sudo touch test-file.txt

#INSTALAR WORDPRESS
# WP installation
echo "Instalando Wordpress"
mkdir /var/www
cd /var/www
aws s3 cp --profile ${environment_name}-ReadAccessToConfigsBucket s3://application-configurations-tnc58anqy8xkj55g/${environment_name}/tf-wp/tf-wp-latest.tgz .
tar -zxvf wpmyportal-latest.tgz