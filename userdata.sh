#!/bin/bash
yum-config-manager --enable epel
yum update -y
yum -y install nfs-utils
mkdir /mnt/efs
mount -t nfs4 -o nfsvers=4.1 $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone).${aws_efs_file_system.efs-wp-base.id.id}.efs."${eu.west-1}".amazonaws.com:/ /mnt/efs
echo "$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone).${aws_efs_file_system.efs-wp-base.id}.efs."${eu.west-1}".amazonaws.com:/ /mnt/efs nfs defaults 0 0" >> /etc/fstab
