resource "aws_security_group" "dv10-wp-base-alb-sg" {
  name        = "dv10-wp-base-alb-sg"
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