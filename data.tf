#data block to fetch latest ami of linux/ubuntu os in primary region
data "aws_ami" "linux_Server_pr" {
  provider           = aws.primary
  owners             = ["amazon"]
  most_recent        = true
  include_deprecated = false

  filter {
    name   = "name"
    values = ["ubuntu-pro-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

#data block to fetch latest ami of linux/ubuntu os in secondary region
data "aws_ami" "linux_Server_sr" {
  provider           = aws.secondary
  owners             = ["amazon"]
  most_recent        = true
  include_deprecated = false

  filter {
    name   = "name"
    values = ["ubuntu/images-testing*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}