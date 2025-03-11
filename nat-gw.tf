#creating Elastic IP for NAT Gateway for Primary region
resource "aws_eip" "nat_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.gw]
  tags = {
    Name = "EIP for NAT gateway"
  }
}

#creating NAT Gateway
resource "aws_nat_gateway" "dev_natgw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public[0].id
  tags = {
    Name = "natgw"
  }
  depends_on = [aws_internet_gateway.gw]
}


###################################################################################

#creating Elastic IP for NAT Gateway for Secondary region
resource "aws_eip" "nat_eip_sr" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.gw_sr]
  tags = {
    Name = "EIP for NAT gateway"
  }
}

#creating NAT Gateway for secondary region
resource "aws_nat_gateway" "dev_natgw_sr" {
  allocation_id = aws_eip.nat_eip_sr.id
  subnet_id     = aws_subnet.public_sr[0].id
  tags = {
    Name = "natgw-sr"
  }
  depends_on = [aws_internet_gateway.gw_sr]
}