resource "aws_security_group" "dv10-sg-wp-base-instances" {
  name        = "dv10-sg-wp-base-instances"
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
  name_prefix   = "dv10-lt-wp-base"
  image_id      =   "ami-031de832435c04744"
  instance_type           = "t2.micro"
  key_name                = "dev-tf-wp-launch-template"
  vpc_security_group_ids = ["${aws_security_group.dv10-sg-wp-base-instances.id}"]

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

resource "aws_autoscaling_group" "dv10-asg-wp-base" {
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1
  vpc_zone_identifier       = "${var.private_subnets}"

  launch_template {
    id      = "${aws_launch_template.dv10-lt-wp-base.id}"
    version = "$Latest"
  }

    tags = {
        Name = "dv10-asg-wp-base"
        Environment = "Development"
        SLA = "8x5"
        Project = "Wordpress Base"
        IaC = "Terraform"
  }
}
