resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "webserver-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2           # Must be high for 2 periods in a row
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120         # Each period = 2 minutes
  statistic           = "Average"
  threshold           = 70          # Trigger when average CPU > 70%
  alarm_actions       = [aws_autoscaling_policy.scale_out.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.petsearch-webserver.name
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "webserver-cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 30          # Trigger when average CPU < 30%
  alarm_actions       = [aws_autoscaling_policy.scale_in.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.petsearch-webserver.name
  }
}