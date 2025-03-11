resource "aws_instance" "web_vm" {
  provider                    = aws.primary
  ami                         = ""
  instance_type               = "t2.micro"
  key_name                    = ""
  subnet_id                   = aws_subnet.public[0].id
  security_groups             = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "Web-Server"
  }

  provisioner "file" {
    source      = "./pswain.pem"
    destination = "/home/ec2-user/pswain.pem"
  }
}

resource "aws_instance" "app_vm" {
  provider                    = aws.primary
  ami                         = ""
  instance_type               = "t2.micro"
  key_name                    = ""
  subnet_id                   = aws_subnet.public[1].id
  security_groups             = [aws_security_group.app_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "App-Server"
  }

  provisioner "file" {
    source      = "./pswain.pem"
    destination = "/home/ec2-user/pswain.pem"
  }
}


##############################################################################

## Creating VMs for Secondary region

resource "aws_instance" "web_vm_sr" {
  provider        = aws.secondary
  ami             = ""
  instance_type   = ""
  subnet_id       = aws_subnet.public_sr[0].id
  security_groups = [aws_security_group.web_sg_sr.id]

  tags = {
    Name = "Web-Server-SR"
  }

  provisioner "file" {
    source      = "./pswain.pem"
    destination = "/home/ec2-user/pswain.pem"
  }
}

resource "aws_instance" "app_vm_sr" {
  provider                    = aws.secondary
  ami                         = ""
  instance_type               = "t2.micro"
  key_name                    = ""
  subnet_id                   = aws_subnet.public_sr[1].id
  security_groups             = [aws_security_group.app_sg_sr.id]
  associate_public_ip_address = true

  tags = {
    Name = "App-Server-SR"
  }

  provisioner "file" {
    source      = "./pswain.pem"
    destination = "/home/ec2-user/pswain.pem"
  }
}