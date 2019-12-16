output "alb_sg_id" {
    value = "aws_security_group.dv10-sg-wp-base-alb.id"    
}
output "alb_arn" {
    value = "aws_lb.dv10-alb-wp-base.id"    
}
output "tg_arn" {
    value = "aws_lb_target_group.dv10-tg-wp-base.id"    
}