# Target Group
resource "aws_lb_target_group" "target_group" {
  name        = "F4target"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.final4_vpc.id

  health_check {
    enabled = true
    path    = "/health"
  }

  depends_on = [aws_alb.ALB]
}

# Application Load Balancer
resource "aws_alb" "ALB" {
  name               = "ALB"
  internal           = false
  load_balancer_type = "application"
  subnets = [
    aws_subnet.publicA.id,
    aws_subnet.publicB.id,
    aws_subnet.publicC.id
  ]

  security_groups = [sg-01f1382b32a3a784d]

  depends_on = [aws_internet_gateway.final4_igw]
}

# ALB Listener
resource "aws_alb_listener" "listener" {
  load_balancer_arn = aws_alb.ALB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

# Output
output "alb_url" {
  value = "http://${aws_alb.ALB.dns_name}"
}
