resource "aws_lb" "primary_alb" {
  provider           = aws.primary
  name               = "primary-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app_sg.id]
  #for_each           = aws_subnet.public
  #subnets            = [each.value.id, aws_subnet.database.id]
  subnets            = concat(aws_subnet.public[*].id, [aws_subnet.database.id])

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
  subnets            = concat(aws_subnet.public_sr[*].id, [aws_subnet.database_sr.id])

  tags = {
    Name = "secondary-alb"
  }
}