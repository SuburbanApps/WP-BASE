#!/bin/bash -xe


echo ECS_CLUSTER=dx-prod-ecs-olpservices-integrations >> /etc/ecs/ecs.config;echo ECS_BACKEND_HOST= >> /etc/ecs/ecs.config;
WHO=$(whoami)
MAC=$(/usr/bin/curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/)
VPC_ID=$(/usr/bin/curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/$MAC/vpc-id)
ZONA_ALL=$(/opt/aws/bin/ec2-metadata -z | cut -d ":" -f 2 | cut -d " " -f 2)
REGION=$(/opt/aws/bin/ec2-metadata -z | cut -d ":" -f 2 | cut -d " " -f 2)
AREA=$(/opt/aws/bin/ec2-metadata -z | cut -d ":" -f 2 | cut -d " " -f 2 | cut -d "-" -f 2)
ZONA=$(/opt/aws/bin/ec2-metadata -z | cut -d ":" -f 2 | cut -d " " -f 2 | cut -d "-" -f 3)
INSTANCE=$(/usr/bin/curl --silent http://169.254.169.254/latest/meta-data/instance-id)
NETWORK=$(/usr/bin/curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/$MAC/subnet-ipv4-cidr-block)
NETLOCAL=$(echo '$NETWORK' | cut -d "." -f 3)
nINSTANCE=$(/opt/aws/bin/ec2-metadata -o | cut -d "." -f 4)
EC2_AVAIL_ZONE=$(/usr/bin/curl --silent http://169.254.169.254/latest/meta-data/placement/availability-zone)
EC2_REGION=$(echo ${ZONA_ALL::-1})
GITLAB_TOKEN=osTjFxsEmRWGKi1KSqNF
PROYECTO=ec2-olpecsservices-integrations
ENTORNO=dx-prod
ASG_NAME="P-09OLPASGCON"
# Asignar Hostname
TAG=$ENTORNO-$PROYECTO-$nINSTANCE
sudo sed -i "s/HOSTNAME=.*/HOSTNAME=$TAG/g" /etc/sysconfig/network
sudo sed -i "s/localhost4.localdomain4.*/localhost4.localdomain4/g" /etc/hosts
sudo sed -i "s/localhost4.localdomain4/localhost4.localdomain4 $TAG/g" /etc/hosts
sudo hostname $TAG
yum install -y aws-cfn-bootstrap
pip install awscli --upgrade --user
export PATH=~/.local/bin:$PATH
aws ec2 create-tags --resources $INSTANCE --tags 'Key=Name,Value='$TAG''
mkdir /var/log/services
EFS_FILE_SYSTEM_ID=fs-aa27d3f3
DIR_SRC=$EFS_FILE_SYSTEM_ID.efs.$EC2_REGION.amazonaws.com
DIR_TGT=/var/log/services
touch /home/ec2-user/echo.res
echo $EFS_FILE_SYSTEM_ID >> /home/ec2-user/echo.res
echo $EC2_AVAIL_ZONE >> /home/ec2-user/echo.res
echo $EC2_REGION >> /home/ec2-user/echo.res
echo $DIR_SRC >> /home/ec2-user/echo.res
echo $DIR_TGT >> /home/ec2-user/echo.res
sudo mount -t nfs4 $DIR_SRC:/ $DIR_TGT >> /home/ec2-user/echo.res
sudo cp -p /etc/fstab /etc/fstab.back-$(date +%F)
echo -e "$DIR_SRC:/          $DIR_TGT          nfs          defaults          0          0" | tee -a /etc/fstab