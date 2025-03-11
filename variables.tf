/*variable "account_id" {
  description = "Account id"
}*/

variable "primary_region" {
  description = "Primary Region Name"
}

variable "secondary_region" {
  description = "Secondary Region Name"
}

variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "egress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "subnet_cidr_blocks" {
  description = "List of CIDR blocks for the subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

# rds varaiables
variable "db_name" {
  description = "Desired DB name"
  type        = string
}

variable "username" {
  description = "Username for DB"
  type        = string
}

variable "password" {
  description = "Password for DB"
  type        = string
}