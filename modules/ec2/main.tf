#Adjuntar variables de entorno
 locals {
  environment_prefix          = "${lookup(local.env.environment_prefix, terraform.workspace, local.environment_prefix)}"
  environment_name            ="${lookup(local.env.environment_name, terraform.workspace, local.environment_name)}"
  //user_data               = "${base64encode(data.template_file.userdata-wp-base.rendered)}" ERROR !!!
    env = {
      environment_prefix = {
        dev     = "dv10"
        staging = "st10"
        live    = "lv10"
          }
    
      environment_name = {
        dev     = "Development"
        staging = "Staging"
        live    = "Live"
        }

  }
  #not_in_production = "${local.not_in_production_mapping[terraform.workspace]}" 
  #not_in_production_mapping = {
    
    #dev         = true
    #staging     = true
    #live        = false
  #}
  }
 
resource "aws_security_group" "sg-wp-base-instances" {
  name        =  "${local.environment_prefix}-sg-wp-base-instances"
  description = "Security Group Instances"
  vpc_id      = "${var.vpc_id}"

  ingress {
    description     = "Traffic from Alb"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    #security_groups = "${var.incoming_sg_ids}"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.environment_prefix}-sg-wp-base-instances"
    Environment = "${local.environment_name}-sg-wp-base-instances"
    Project = "Wordpress Base"
    IaC = "Terraform"
  }
}

resource "aws_launch_template" "lt-wp-base" {
  name_prefix = "${local.environment_prefix}ltwpbaseinstances"
  image_id  =  "ami-01f14919ba412de34"
  instance_type = "t2.micro"
  key_name = "${var.key_pair}"
  vpc_security_group_ids = ["${aws_security_group.sg-wp-base-instances.id}"]
  user_data               = "${base64encode(data.template_file.userdata-wp-base.rendered)}" 

  tag_specifications {
    resource_type = "instance"
      tags          = {
        Name = "${local.environment_prefix}-lt-wp-base-instances"
        Environment = "${local.environment_name}-lt-wp-base-instances"
        Project = "Wordpress Base"
        IaC = "Terraform"
        SLA = "8x5"
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags          = {
        Name = "${local.environment_prefix}-lt-wp-base-instances"
        Environment = "${local.environment_name}-lt-wp-base-instances"
        Project = "Wordpress Base"
        IaC = "Terraform"
        SLA = "8x5"
    }
  }

  tags = {
       Name = "${local.environment_prefix}-lt-wp-base-instances"
        Environment = "${local.environment_name}-lt-wp-base-instances"
        Project = "Wordpress Base"
        IaC = "Terraform"
        SLA = "8x5"
  }
}
data "template_file" "userdata-wp-base" {
  template = "${file("userdata.sh")}"
  vars = {
    aws_region        = "eu-west-1"
    environment_name  = "${local.environment_name}"
    rds_user          = "${local.environment_name}-rds-user"
    rds_root_password = "12345678"
    rds_user_password = "12345678"  
  }
}
resource "aws_autoscaling_group" "asg-wp-base" {
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1
  vpc_zone_identifier  = "${var.private_subnets}"
  #target_group_arns = "${var.target_group_arns}"

  health_check_type = "EC2" // temporalmente para las pruebas

  launch_template {
    id      = "${aws_launch_template.lt-wp-base.id}"
    version = "$Latest"
  }

  tags = [
    {
      key                 = "Name"
      value               = "asg-wp-base"
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

resource "aws_autoscaling_schedule" "asg-wp-base-sheduleUp" { 
  count                   = 1
  scheduled_action_name   = "asg-wp-base-sheduleUp"
  recurrence              = "0 6 * * MON-FRI"
  min_size                = 1
  max_size                = 2
  desired_capacity        = 1
  autoscaling_group_name  = "${aws_autoscaling_group.asg-wp-base.name}"
}
resource "aws_autoscaling_schedule" "asg-wp-base-sheduledown" {
  count                   = 1
  scheduled_action_name   = "asg-wp-base--scheduledown"
  recurrence              = "0 18 * * MON-FRI"
  min_size                = 0
  max_size                = 0
  desired_capacity        = 0
  autoscaling_group_name  = "${aws_autoscaling_group.asg-wp-base.name}"
}
 