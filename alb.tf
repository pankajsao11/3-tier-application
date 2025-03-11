resource "aws_lb" "primary_alb" {
  provider           = aws.primary
  name               = "primary-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app_sg.id]
  for_each           = aws_subnet.public
  subnets            = [each.value.id, aws_subnet.database.id]

  tags = {
    Name = "primary-alb"
  }
}