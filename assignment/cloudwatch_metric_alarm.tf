resource "aws_cloudwatch_metric_alarm" "cpu_alert" {
  alarm_name                = "cpu_alert"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "40"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.nginx.name}"
  }
  actions_enabled = true
  alarm_actions = [ "${aws_autoscaling_group.cpu-policy-for-counter-app.arn}" ]
}