UserData:
  Fn::Base64:
    !Sub |
      #!/bin/bash -xe
      yum update -y
      yum install -y aws-cfn-bootstrap awscli nfs-utils cloud-init
      /opt/aws/bin/cfn-init -v --stack ${AWS::StackName} --resource MasterInstances --region ${AWS::Region} -c ascending
      /opt/aws/bin/cfn-signal -e $? --stack ${AWS::StackName} --resource MasterAutoScalingGroup --region ${AWS::Region}
      mkdir -p ${EfsMountPoint1}
      mkdir -p ${EfsMountPoint2}
      chown ${EfsMountOwner1}:${EfsMountOwner1} ${EfsMountPoint1}
      chown ${EfsMountOwner2}:${EfsMountOwner2} ${EfsMountPoint2}
      echo "$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone).${EfsFileSystemId1}.efs.aws-region.amazonaws.com:/ ${EfsMountPoint1} nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 0 0" >> /etc/fstab
      echo "$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone).${EfsFileSystemId2}.efs.aws-region.amazonaws.com:/ ${EfsMountPoint2} nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 0 0" >> /etc/fstab
      mount -a -t nfs4