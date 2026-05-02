# Email Subscriptions
resource "aws_sns_topic_subscription" "email" {
  for_each = local.topics

  topic_arn = aws_sns_topic.alerts[each.key].arn
  protocol  = "email"
  endpoint  = var.alert_email
}


# SNS Topics

resource "aws_sns_topic" "alerts" {
  for_each = local.topics

  name         = "${var.name_prefix}-${each.key}"
  display_name = each.value.display_name

  # Enforce HTTPS delivery
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowPublishFromEC2"
        Effect = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
        Action   = "SNS:Publish"
        Resource = "*"
      },
      {
        Sid    = "AllowPublishFromAccountOwner"
        Effect = "Allow"
        Principal = { AWS = data.aws_caller_identity.current.arn }
        Action   = ["SNS:Publish", "SNS:Subscribe", "SNS:ListSubscriptionsByTopic"]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name        = "${var.name_prefix}-${each.key}"
    AlertType   = each.key
  }
}

data "aws_caller_identity" "current" {}