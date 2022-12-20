
##################################################################################
# RESOURCES
##################################################################################

# SECURITY GROUPS #
# ALB Security Group
resource "aws_security_group" "public-alb_sg" {
  name   = "${local.name_prefix}-nginx_alb_sg"
  vpc_id = aws_default_vpc.default.id

  #Allow Port 80 from Anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags

}


resource "aws_lb" "public-alb" {
  name               = "${local.name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  # subnets            = aws_default_subnet.default[*].id

  dynamic "subnet_mapping" {
    for_each = aws_default_subnet.default_subnet

    content {
      subnet_id = subnet_mapping.value.id
    }
  }
  enable_deletion_protection = false

  access_logs {
    bucket  = local.s3_bucket_name
    prefix  = "alb-logs"
    enabled = true
  }

  tags = local.common_tags
}

resource "aws_lb_target_group" "public-alb" {
  name     = "${local.name_prefix}-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_default_vpc.default.id
}

resource "aws_lb_listener" "public-alb" {
  load_balancer_arn = aws_lb.public-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.public-alb.arn
  }

  tags = local.common_tags
}

## Currently using auto scaling group load balancer
# resource "aws_lb_target_group_attachment" "nginx" {
#   count            = var.instance_count
#   target_group_arn = aws_lb_target_group.nginx.arn
#   target_id        = aws_instance.nginx[count.index].id
#   port             = 80
# }