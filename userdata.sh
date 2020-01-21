UserData:
  Fn::Base64:
    !Sub |
      yum update -y
      yum install -y aws-cfn-bootstrap awscli nfs-utils cloud-init
      /opt/aws/bin/cfn-init -v --stack ${AWS::StackName} --resource MasterInstances --region ${AWS::Region} -c ascending
      /opt/aws/bin/cfn-signal -e $? --stack ${AWS::StackName} --resource MasterAutoScalingGroup --region ${AWS::Region}
      mkdir -p ${EfsMountPoint1}
      mkdir -p ${EfsMountPoint2}
      chown ${EfsMountOwner1}:${EfsMountOwner1} ${EfsMountPoint1}
      chown ${EfsMountOwner2}:${EfsMountOwner2} ${EfsMountPoint2}
    