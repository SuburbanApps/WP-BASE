#!bin/bash
sudo yum install -y amazon-efs-utils        
        
       #montaje EFS dentro de la instancia EC2
       mkdir ~/efs-mount-point 
      sudo mount -t nfs -o
 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ip-172-31-53-187.eu-west-1.compute.internal:/ ~/efs-mount-point
 cd ~/efs-mount-point
 sudo chmod go+rw . 


       