#Configuracion ALB

resource "aws_lb" "tf-wp-balanceador" {
  name               = "tfwpalb"
  internal           = false
  load_balancer_type = "application"
  #security_groups    = ["${aws_security_group.tf_wp_AlbSecurityGroup.id}"]
  subnets            = "${var.subredes}"
}


resource "aws_lb_listener" "MyportalListenerSSL" { //80 listener 
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

resource "aws_lb_listener" "MyportalListenerSSL" { //80 listener 
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
resource "aws_lb_target_group" "tf_wp_TargetGroup"  {
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