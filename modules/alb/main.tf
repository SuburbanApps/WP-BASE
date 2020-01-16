locals {
  environment_prefix          =  "dev"##"${lookup(local.env.environment_prefix, terraform.workspace)}"
  environment_name            = "${lookup(local.env.environment_name, terraform.workspace)}"
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
  
  
  not_in_production = "${local.not_in_production_mapping[terraform.workspace]}" 
  not_in_production_mapping = {
    dev         = true
    staging     = true
    live        = false
  }
  
 }

 resource "aws_security_group" "sg-wp-base-alb" {
  name        =  "${local.environment_prefix}-sg-wp-base-alb" 
  description = "Security Group for Application Load Balancer"
  vpc_id      = "${var.vpc_id}"

  ingress {
    description     = "HTTP from internet"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name =  "${local.environment_prefix}-sg-wp-base-alb"
    Environment = "${local.environment_name}"
    Project = "Wordpress Base"
    IaC = "Terraform"
  }
}

resource "aws_lb" "alb-wp-base" {
  name               = "${local.environment_prefix}-wp-base-alb" 
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.sg-wp-base-alb.id}"]
  subnets            = "${var.public_subnets}"

  tags = {
    Name =  "${local.environment_prefix}-wp-base-alb"
    Environment = "${local.environment_name}"
    Project = "Wordpress Base"
    IaC = "Terraform"
  }
}

resource "aws_lb_target_group" "tg-wp-base" { 
  name        = "${local.environment_prefix}-tg-base-alb" 
  port        = "80"
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = "${var.vpc_id}"

  health_check {
    interval            = "15"
    path                = "/health-check.php"
    healthy_threshold   = "2"
    unhealthy_threshold = "2"
    timeout             = "10"
    protocol            = "HTTP"
  }

  stickiness {
    type            = "lb_cookie"
    cookie_duration = "86400"
    enabled         = "true"
  }

  tags = {
    Name =  "${local.environment_prefix}-tg-base-alb"
    Environment = "Development"
    Project = "Wordpress Base"
    IaC = "Terraform"
  }

}

resource "aws_lb_listener" "listener-wp-base" {
  load_balancer_arn = "${aws_lb.alb-wp-base.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.tg-wp-base.id}"
  }
}