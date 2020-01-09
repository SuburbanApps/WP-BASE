resource "aws_security_group" "dv10-sg-wp-base-alb" {
  name        =  "${local.environment_prefix}"
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
    Name = "dv10-sg-wp-base-alb"
    Environment = "Development"
    Project = "Wordpress Base"
    IaC = "Terraform"
  }
}
tags = "${merge(
    local.wp_base_common_tags,
    map(
      "Name", "${local.environment_prefix}-wpmyportal-alb"
    )
  )}
resource "aws_lb" "dv10-alb-wp-base" {
  name               = "albwpbase" ##${local.environment_prefix}-
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.dv10-sg-wp-base-alb.id}"]
  subnets            = "${var.public_subnets}"

  tags = {
    Name = "dv10-alb-wp-base"
    Environment = "Development"
    Project = "Wordpress Base"
    IaC = "Terraform"
  }
}

resource "aws_lb_target_group" "dv10-tg-wp-base" { //WP Empleo Target Group
  name        = "tgwpbase" ##${local.environment_prefix}-
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