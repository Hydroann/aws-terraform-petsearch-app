resource "aws_lb" "main" {
  name               = "petsearch-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = [aws_subnet.public-petsearch-subnet-1, aws_subnet.public-petsearch-subnet-2]

  
  access_logs {
    bucket  = aws_s3_bucket.documents
    prefix  = "documents"
    enabled = true
  }

  tags = { Name = "petsearch-alb" }
}

resource "aws_lb_target_group" "webserver" {
  name        = "petsearch-webserver-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.petsearch.id
  target_type = "instance"


  health_check {
    path                = "/"        # Check the homepage
    protocol            = "HTTP"
    matcher             = "200,302"  # Accept OK and redirect responses
    interval            = 30         # Check every 30 seconds
    timeout             = 5          # Wait 5 seconds max for a response
    healthy_threshold   = 2          # 2 successes in a row = healthy
    unhealthy_threshold = 3          # 3 failures in a row = unhealthy
  }

  # Sticky sessions: one user always hits the same server. This prevents WordPress from logging users out unexpectedly
  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400   # 1 day
    enabled         = true
  }

  tags = { Name = "petsearch-webserver-tg" }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webserver.arn
  }
}