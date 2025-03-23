/*
# Hosted Zone (if not created)
resource "aws_route53_zone" "myzone" {
  name = "example.com"
}

# Route 53 Record for Primary ALB
resource "aws_route53_record" "primary_alb" {
  zone_id = aws_route53_zone.myzone.zone_id
  name    = "app.example.com"
  type    = "A"

  set_identifier = "primary"
  failover_routing_policy {
    type = "PRIMARY"
  }

  alias {
    name                   = aws_lb.primary_lb.dns_name
    zone_id                = aws_lb.primary_lb.zone_id
    evaluate_target_health = true
  }
}

# Route 53 Record for Secondary ALB
resource "aws_route53_record" "secondary_alb" {
  zone_id = aws_route53_zone.myzone.zone_id
  name    = "app.example.com"
  type    = "A"

  set_identifier = "secondary"
  failover_routing_policy {
    type = "SECONDARY"
  }

  alias {
    name                   = aws_lb.secondary_lb.dns_name
    zone_id                = aws_lb.secondary_lb.zone_id
    evaluate_target_health = true
  }
}

*/