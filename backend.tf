/*
variable "instance_ids_primary" {
  description = "List of instance IDs for the primary region"
  type        = list(string)
}

variable "instance_ids_secondary" {
  description = "List of instance IDs for the secondary region"
  type        = list(string)
}
2. Create ALBs in Both Regions

resource "aws_lb" "secondary_alb" {
  provider           = aws.secondary
  name               = "secondary-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.secondary_subnet_ids

  tags = {
    Name = "secondary-alb"
  }
}
3. Create Target Groups
resource "aws_lb_target_group" "primary_tg" {
  provider = aws.primary
  name     = "primary-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.primary_vpc.id

  health_check {
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "primary-tg"
  }
}

resource "aws_lb_target_group" "secondary_tg" {
  provider = aws.secondary
  name     = "secondary-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.secondary_vpc.id

  health_check {
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "secondary-tg"
  }
}
4. Create Listeners
resource "aws_lb_listener" "primary_listener" {
  provider           = aws.primary
  load_balancer_arn  = aws_lb.primary_alb.arn
  port               = 80
  protocol           = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.primary_tg.arn
  }
}

resource "aws_lb_listener" "secondary_listener" {
  provider           = aws.secondary
  load_balancer_arn  = aws_lb.secondary_alb.arn
  port               = 80
  protocol           = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.secondary_tg.arn
  }
}
5. Register Targets
resource "aws_lb_target_group_attachment" "primary_tg_attachment" {
  provider          = aws.primary
  count             = length(var.instance_ids_primary)
  target_group_arn  = aws_lb_target_group.primary_tg.arn
  target_id         = var.instance_ids_primary[count.index]
  port              = 80
}

resource "aws_lb_target_group_attachment" "secondary_tg_attachment" {
  provider          = aws.secondary
  count             = length(var.instance_ids_secondary)
  target_group_arn  = aws_lb_target_group.secondary_tg.arn
  target_id         = var.instance_ids_secondary[count.index]
  port              = 80
}
6. Use AWS Global Accelerator (Optional)
resource "aws_globalaccelerator_accelerator" "example" {
  name               = "example-accelerator"
  enabled            = true
  ip_address_type    = "IPV4"

  attributes {
    flow_logs_enabled = false
  }
}

resource "aws_globalaccelerator_listener" "example" {
  accelerator_arn = aws_globalaccelerator_accelerator.example.id
  protocol        = "TCP"
  port_ranges {
    from_port = 80
    to_port   = 80
  }
}

resource "aws_globalaccelerator_endpoint_group" "primary" {
  listener_arn = aws_globalaccelerator_listener.example.id
  endpoint_configuration {
    endpoint_id = aws_lb.primary_alb.arn
    weight      = 128
  }
  region = "us-west-2"
}

resource "aws_globalaccelerator_endpoint_group" "secondary" {
  listener_arn = aws_globalaccelerator_listener.example.id
  endpoint_configuration {
    endpoint_id = aws_lb.secondary_alb.arn
    weight      = 128
  }
  region = "us-east-1"
}
Example terraform.tfvars File
primary_subnet_ids = [
  "subnet-0123456789abcdef0",
  "subnet-0123456789abcdef1"
]

secondary_subnet_ids = [
  "subnet-abcdef01234567890",
  "subnet-abcdef01234567891"
]

security_group_ids = [
  "sg-0123456789abcdef0"
]

instance_ids_primary = [
  "i-0123456789abcdef0",
  "i-0123456789abcdef1"
]

instance_ids_secondary = [
  "i-abcdef01234567890",
  "i-abcdef01234567891"
]



variable "domain_name" {
  description = "The domain name for the application"
  type        = string
}

variable "primary_alb_dns_name" {
  description = "DNS name of the primary ALB"
  type        = string
}

variable "primary_alb_zone_id" {
  description = "Zone ID of the primary ALB"
  type        = string
}

variable "secondary_alb_dns_name" {
  description = "DNS name of the secondary ALB"
  type        = string
}

variable "secondary_alb_zone_id" {
  description = "Zone ID of the secondary ALB"
  type        = string
}
2. Create Route 53 Hosted Zone
resource "aws_route53_zone" "main" {
  name = var.domain_name
}
3. Create DNS Records for Failover
resource "aws_route53_record" "primary" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.primary_alb_dns_name
    zone_id                = var.primary_alb_zone_id
    evaluate_target_health = true
  }

  failover_routing_policy {
    type = "PRIMARY"
  }
}

resource "aws_route53_record" "secondary" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.secondary_alb_dns_name
    zone_id                = var.secondary_alb_zone_id
    evaluate_target_health = true
  }

  failover_routing_policy {
    type = "SECONDARY"
  }
}
Example terraform.tfvars File
domain_name = "app.example.com"

primary_alb_dns_name = "primary-alb-1234567890.us-west-2.elb.amazonaws.com"
primary_alb_zone_id  = "Z3DZXE0Q79N41H"

secondary_alb_dns_name = "secondary-alb-0987654321.us-east-1.elb.amazonaws.com"
secondary_alb_zone_id  = "Z35SXDOTRQ7X7K"
*/