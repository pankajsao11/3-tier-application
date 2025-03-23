#creating vpc for our application in primary region

resource "aws_vpc" "app_vpc" {
  provider   = aws.primary
  cidr_block = "10.0.0.0/20"

  tags = {
    name = "multi-tier-vpc"
  }
}

resource "aws_subnet" "public" {
  provider                = aws.primary
  count                   = 2
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = var.subnet_cidr_blocks[count.index]
  availability_zone       = var.availability_zones_pr[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = count.index == 0 ? "web-subnet" : "app-subnet"
  }
}

resource "aws_subnet" "database" {
  provider                = aws.primary
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1c"

  tags = {
    Name = "database-subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  provider = aws.primary
  vpc_id   = aws_vpc.app_vpc.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "public_route" {
  provider = aws.primary
  vpc_id   = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "pub-route-table"
  }
}

resource "aws_route_table_association" "public" {
  provider = aws.primary
  #for_each       = aws_subnet.public
  for_each       = { for index, subnet in aws_subnet.public : index => subnet }
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route.id
}

##############################################################################

#creating vpc for our application in Secondary region

resource "aws_vpc" "app_vpc_sr" {
  provider   = aws.secondary
  cidr_block = "10.0.0.0/22"

  tags = {
    name = "multi-tier-vpc"
  }
}

resource "aws_subnet" "public_sr" {
  provider                = aws.secondary
  count                   = 2
  vpc_id                  = aws_vpc.app_vpc_sr.id
  cidr_block              = var.subnet_cidr_blocks[count.index]
  availability_zone       = var.availability_zones_sr[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = count.index == 0 ? "web-subnet-sr" : "app-subnet-sr"
  }
}

resource "aws_subnet" "database_sr" {
  provider                = aws.secondary
  vpc_id                  = aws_vpc.app_vpc_sr.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-west-2c"

  tags = {
    Name = "database-subnet-sr"
  }
}

resource "aws_internet_gateway" "gw_sr" {
  provider = aws.secondary
  vpc_id   = aws_vpc.app_vpc_sr.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "public_route_sr" {
  provider = aws.secondary
  vpc_id   = aws_vpc.app_vpc_sr.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw_sr.id
  }

  tags = {
    Name = "pub-route-table"
  }
}

resource "aws_route_table_association" "rt_public_sr" {
  provider       = aws.secondary
  for_each       = { for index, subnet in aws_subnet.public_sr : index => subnet }
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route_sr.id
}