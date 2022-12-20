
#Create Launch config
resource "aws_launch_configuration" "nginx" {
  name_prefix          = var.naming_prefix
  image_id             = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type        = var.instance_type
  security_groups      = ["${aws_security_group.nginx_sg.id}"]
  iam_instance_profile = aws_iam_instance_profile.nginx_profile.name
  depends_on           = [aws_iam_role_policy.allow_s3_all]

  lifecycle {
    create_before_destroy = true
  }
  user_data = templatefile("${path.module}/startup_script.tpl", {
    s3_bucket_name = local.s3_bucket_name
  })
}

#Create Auto Scaling Group
resource "aws_autoscaling_group" "nginx" {
  count                     = length(var.vpc_private_subnet_cidr_blocks)
  name                      = var.project
  min_size                  = 1
  max_size                  = 3
  desired_capacity          = 1
  launch_configuration      = aws_launch_configuration.nginx.name
  vpc_zone_identifier       = [element(aws_subnet.private_subnets[*].id, count.index)]
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete              = true
  target_group_arns         = ["${aws_lb_target_group.nginx.arn}"]


  tag {
    key                 = "Autoscaling"
    value               = "Autocaling Group for Nginx Instance"
    propagate_at_launch = true
  }
}

# Create a new ALB Target Group attachment
# resource "aws_autoscaling_attachment" "nginx_instance" {
#     autoscaling_group_name = "${element(aws_autoscaling_group.nginx.*.id, count.index)}"
# #   autoscaling_group_name = aws_autoscaling_group.nginx.id
#   lb_target_group_arn    = aws_lb_target_group.nginx.arn
# }

resource "aws_autoscaling_policy" "cpu-policy-for-counter-app" {
  name                   = "cpu"
  scaling_adjustment     = 2
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.nginx.name
}
