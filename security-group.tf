resource "aws_security_group" "web_sg" {
  provider = aws.primary
  vpc_id   = aws_vpc.app_vpc.id

  # Dynamic block for ingress rules
  # Loops through ingress_rules and applies settings for each
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = {
    Name = "Web-SG"
  }
}

resource "aws_security_group" "app_sg" {
  provider = aws.primary
  vpc_id   = aws_vpc.app_vpc.id
  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "App-SG"
  }
}

resource "aws_security_group" "db_sg" {
  provider = aws.primary
  vpc_id   = aws_vpc.app_vpc.id
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DB-SG"
  }
}


#############################################################################

##Security group resource creation for Secondary region

resource "aws_security_group" "web_sg_sr" {
  provider = aws.secondary
  vpc_id   = aws_vpc.app_vpc_sr.id

  # Dynamic block for ingress rules
  # Loops through ingress_rules and applies settings for each
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = {
    Name = "Web-SG-SR"
  }
}

resource "aws_security_group" "app_sg_sr" {
  provider = aws.secondary
  vpc_id   = aws_vpc.app_vpc_sr.id
  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg_sr.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "App-SG-SR"
  }
}

resource "aws_security_group" "db_sg_sr" {
  provider = aws.secondary
  vpc_id   = aws_vpc.app_vpc.id
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg_sr.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DB-SG-SR"
  }
}