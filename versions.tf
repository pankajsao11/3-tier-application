##14-secrets reference

terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.primary_region
  alias  = "primary"
  #allowed_account_ids = var.account_id
}

provider "aws" {
  region = var.secondary_region
  alias  = "secondary"
  #allowed_account_ids = var.account_id
}
