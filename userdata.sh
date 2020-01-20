#!bin/bash -xe

sudo yum install -y amazon-efs-utils        
        
       #montaje EFS dentro de la instancia EC2
       mkdir ~/efs-mount-point 
       sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs-wp-base}.efs.${AWS::eu-west-1}.amazonaws.com:/ ~/efs-mount-point
       cd ~/efs-mount-point  
       ls -al
       sudo chmod go+rw
       ls -l


       