#Configuracion ALB

resource "aws_security_group" "wp-alb-sg" { // myportal ALB group
  name        = "dev-wp-alb-sg" //hacerlo mas adelante con variables.
  description = "SG for TPZCom Public Alb"
  vpc_id      = "${var.vpcidentificador}"

  ingress {
    description = "From All"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "From All"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  
}

resource "aws_lb" "dev10-tf-wp-alb" {
  name               = "Balanceador"
  internal           = false
  load_balancer_type = "application"
  #security_groups    = ["${aws_security_group.tf_wp_AlbSecurityGroup.id}"]
  subnets            = "${var.subredes}"
}


resource "aws_lb_listener" "dev-tf-wp-listener443" {
  #load_balancer_arn = "${aws_lb.MyportalPublicAlb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${local.public_certificate_arn}"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.tf_wp_TargetGroup.arn}"
  }
}

resource "aws_lb_listener" "dev-tf-wp-listener80" {
  #load_balancer_arn = "${aws_lb.MyportalPublicAlb.arn}"
  port              = "80"
  protocol          = "HTTP"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${local.public_certificate_arn}"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.tf_wp_TargetGroup.arn}"
  }
}
resource "aws_lb_target_group" "dev10-tf-wp-TargetGroup"  {
  name        = "devtfwptg"
  port        = "80"
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      =  "${var.vpcidentificador}"

  health_check {
    interval            = "15"
    #path                = "/health-check.php"
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
}