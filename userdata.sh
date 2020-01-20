#!bin/bash -xe
sudo yum install -y amazon-efs-utils        
        
        #EFS mount
         mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 ${ElasticFileSystem}.efs.${AWS::Region}.amazonaws.com:/ /opt/apps/htdocs/sites/files

          # Setup fstab to auto mount EFS

          echo "${ElasticFileSystem}.efs.${AWS::Region}.amazonaws.com:/ /opt/apps/htdocs/sites/files nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,nofail 0 0" | sudo tee -a /etc/fstab