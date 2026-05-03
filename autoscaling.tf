resource "aws_autoscaling_group" "petsearch-webserver" {
  name = "petsearch-webserver-asg"

  # Server count limits
  min_size         = var.asg_min_size         # Never go below this
  max_size         = var.asg_max_size         # Never go above this
  desired_capacity = var.asg_desired_capacity # Start with this many

  # Deploy across both private subnets (spreads across AZ-1 and AZ-2)
  vpc_zone_identifier = [aws_subnet.private-petsearch-subnet-1.id, aws_subnet.private-petsearch-subnet-2.id]

  # Register instances with the ALB so it sends them traffic
  target_group_arns = [aws_lb_target_group.webserver.arn]

  # Use ALB health checks — if Webserver is broken, replace the instance
  health_check_type         = "ELB"
  health_check_grace_period = 300   # Wait 5 min after launch before checking

  launch_template {
    id      = aws_launch_template.webserver.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "petsearch-webserver"
    propagate_at_launch = true
  }

  # The ASG depends on the DB and S3 being ready before starting
 # depends_on = [aws_db_instance.rds-instance, aws_s3_bucket.pet_images]
}


# Scale OUT: add a server when busy
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "web-scale-out"
  autoscaling_group_name = aws_autoscaling_group.petsearch-webserver.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1      # Add 1 instance
  cooldown               = 300    # Then wait 5 min before scaling again
}

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

# Scale IN: remove a server when quiet
resource "aws_autoscaling_policy" "scale_in" {
  name                   = "webserver-scale-in"
  autoscaling_group_name = aws_autoscaling_group.petsearch-webserver.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1     # Remove 1 instance
  cooldown               = 300
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

#LAUNCH TEMPLATE AND WORDPRESS INSTALL SCRIPT
locals {
  userdata = base64encode(templatefile("scripts/userdata.sh", {
    db_username    = var.db_username
    db_password    = var.db_password
   # s3_bucket_name = aws_s3_bucket.pet_images.bucket
  }))
}

resource "aws_launch_template" "webserver" {
  name_prefix   = "webserver-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.petsearch-web-sg.id]
  # The install script that runs at first boot
  user_data = local.userdata

  # Root disk: 20 GB SSD
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 20
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }

  # Tag each instance created from this template
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "petsearch-webserver"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
