resource "aws_security_group" "dv10-sg-wp-base-instances" {
  name        = "sgwpbaseinstances" ##${local.environment_prefix}-
  description = "Security Group Instances"
  vpc_id      = "${var.vpc_id}"

  ingress {
    description     = "Traffic from Alb"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = "${var.incoming_sg_ids}"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dv10-sg-wp-base-instances"
    Environment = "Development"
    Project = "Wordpress Base"
    IaC = "Terraform"
  }
}

resource "aws_launch_template" "dv10-lt-wp-base" {
  name_prefix = "dev" #${local.environment_prefix}-
  image_id  =  "ami-01f14919ba412de34"
  instance_type = "t2.micro"
  key_name = "${var.key_pair}"
  vpc_security_group_ids = ["${aws_security_group.dv10-sg-wp-base-instances.id}"]
  user_data               = "${base64encode(data.template_file.dv10-userdata-wp-base.rendered)}"

  tag_specifications {
    resource_type = "instance"
    tags          = {
        Name = "wp-base"
        Environment = "Development"
        SLA = "8x5"
        Project = "Wordpress Base"
        IaC = "Terraform"
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags          = {
        Name = "wp-base"
        Environment = "Development"
        SLA = "8x5"
        Project = "Wordpress Base"
        IaC = "Terraform"
    }
  }

  tags = {
        Name = "wp-base"
        Environment = "Development"
        SLA = "8x5"
        Project = "Wordpress Base"
        IaC = "Terraform"
  }
}
data "template_file" "dv10-userdata-wp-base" {
  template = "${file("userdata.sh")}"
  vars = {
    aws_region        = "eu-west-1"
    environment_name  = "dev"
    #rds_dnsname       = "${aws_db_instance.dv10-db-wp-base.address}"
    #shared_account_id = "${local.aws_shared_accountid}"
    rds_user          = "dev-rds-user"
    rds_root_password = "12345678"
    rds_user_password = "12345678"  
  }
}
resource "aws_autoscaling_group" "dv10-asg-wp-base" {
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1
  vpc_zone_identifier       = "${var.private_subnets}"
  target_group_arns = "${var.target_group_arns}"

  health_check_type = "EC2" // temporalmente para las pruebas

  launch_template {
    id      = "${aws_launch_template.dv10-lt-wp-base.id}"
    version = "$Latest"
  }

  tags = [
    {
      key                 = "Name"
      value               = "dv10-asg-wp-base"
      propagate_at_launch = false
    },
    {
      key                 = "Project"
      value               = "Wordpress Base"
      propagate_at_launch = false
    },
    {
      key                 = "Environment"
      value               = "Development"
      propagate_at_launch = false
    },
    {
      key                 = "IaC"
      value               = "Terraform"
      propagate_at_launch = false
    },
    {
      key                 = "SLA"
      value               = "8x5"
      propagate_at_launch = false
    }
  ]
}

resource "aws_autoscaling_schedule" "dv10-asg-wp-base-sheduleUp" { 
  count                   = "1"
  scheduled_action_name   = "asg-wp-base-sheduleUp"
  recurrence              = "0 6 * * MON-FRI"
  min_size                = 1
  max_size                = 2
  desired_capacity        = 1
  autoscaling_group_name  = "${aws_autoscaling_group.dv10-asg-wp-base.name}"
}
