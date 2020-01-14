locals {
  Environment = "${local.environment_name}"
}
resource "aws_security_group" "dv10-sg-wp-base-alb" 
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

resource "aws_lb" "dv10-alb-wp-base" {
  name               = "${local.environment_prefix}-wp-base-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.dv10-sg-wp-base-alb.id}"]
  subnets            = "${var.public_subnets}"

  tags = {
    Name =  "${local.environment_prefix}-wp-base-alb"
    Environment = "Development"
    Project = "Wordpress Base"
    IaC = "Terraform"
  }
}

resource "aws_lb_target_group" "dv10-tg-wp-base" { 
  name        = "tgwpbase"
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
    Name = "dv10-tg-wp-base"
    Environment = "Development"
    Project = "Wordpress Base"
    IaC = "Terraform"
  }

}

resource "aws_lb_listener" "dv10-listener-wp-base" {
  load_balancer_arn = "${aws_lb.dv10-alb-wp-base.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.dv10-tg-wp-base.id}"
  }
}