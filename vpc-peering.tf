resource "aws_vpc_peering_connection" "peer" {
  provider    = aws.primary
  vpc_id      = aws_vpc.app_vpc.id
  peer_vpc_id = aws_vpc.app_vpc_sr.id
  peer_region = var.secondary_region # Replace with your secondary region

  tags = {
    Name = "primary-to-secondary"
  }
}

resource "aws_vpc_peering_connection_accepter" "peer_accepter" {
  provider                  = aws.secondary
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  auto_accept               = true

  tags = {
    Name = "secondary-to-primary"
  }
}