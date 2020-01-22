#!/bin/bash
yum-config-manager --enable epel
yum update -y
yum -y install nfs-utils
mkdir /mnt/efs
