##< ALB for both regions >##

resource "aws_lb" "primary_alb" {
  provider           = aws.primary
  name               = "primary-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app_sg.id]
  #for_each           = aws_subnet.public
  #subnets            = [each.value.id, aws_subnet.database.id]
  subnets = concat(aws_subnet.public[*].id, [aws_subnet.database.id])

  tags = {
    Name = "primary-alb"
  }
}

resource "aws_lb" "secondary_alb" {
  provider           = aws.secondary
  name               = "secondary-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app_sg_sr.id]
  #for_each           = aws_subnet.public_sr
  subnets = concat(aws_subnet.public_sr[*].id, [aws_subnet.database_sr.id])

  tags = {
    Name = "secondary-alb"
  }
}

#####################################################################################

##< Target group >##
resource "aws_lb_target_group" "primary_tg" {
  provider = aws.primary
  name     = "primary-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.app_vpc.id
}

resource "aws_lb_target_group" "secondary_tg" {
  provider = aws.secondary
  name     = "secondary-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.app_vpc_sr.id
}

# Attach Web & App Instances to Primary Target Group
resource "aws_lb_target_group_attachment" "web_primary" {
  target_group_arn = aws_lb_target_group.primary_tg.arn
  target_id        = aws_instance.web_vm.id
}

resource "aws_lb_target_group_attachment" "app_primary" {
  target_group_arn = aws_lb_target_group.primary_tg.arn
  target_id        = aws_instance.app_vm.id
}

# Attach Web & App Instances to Secondary Target Group
resource "aws_lb_target_group_attachment" "web_secondary" {
  provider         = aws.secondary
  target_group_arn = aws_lb_target_group.secondary_tg.arn
  target_id        = aws_instance.web_vm_sr.id
}

resource "aws_lb_target_group_attachment" "app_secondary" {
  provider         = aws.secondary
  target_group_arn = aws_lb_target_group.secondary_tg.arn
  target_id        = aws_instance.app_vm_sr.id
}

####################################################################################

## Listeners for the target group ##

# Listener for Primary ALB (Forwarding Requests to Target Group)

resource "aws_lb_listener" "primary_http" {
  load_balancer_arn = aws_lb.primary_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.primary_tg.arn
  }
}

# Listener for Secondary ALB (Forwarding Requests to Target Group)
resource "aws_lb_listener" "secondary_http" {
  provider          = aws.secondary
  load_balancer_arn = aws_lb.secondary_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.secondary_tg.arn
  }
}