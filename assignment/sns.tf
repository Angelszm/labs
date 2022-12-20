##SNS Topic Creation
resource "aws_sns_topic" "cpu-sns" {
  name = "server-fleet-cpu-sns"
  display_name = "Auto Scaling Group SNS Topic"
}

## SNS Topic with autoscaling group
resource "aws_autoscaling_notification" "notifications" {
  group_names = [
    aws_autoscaling_group.nginx.name
    ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.cpu-sns.arn
}