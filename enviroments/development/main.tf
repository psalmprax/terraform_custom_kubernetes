# Provider Configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.46.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
  }
}

provider "aws" {
  default_tags {
    tags = {
      ManagedBy = "Terraform"
    }
  }
}



module "workload-development" {
  source = "../../resources"

  vpc_cidr            = "15.55.0.0/16"
  public_subnet_cdir  = ["15.55.1.0/24"]
  private_subnet_cdir = ["15.55.10.0/24"]
  instance_type       = "t3.xlarge"
  alert_email_address = "samuelolle@yahoo.com"
  kubernetes_token    = ""
  kubernetes_ca_cert_hash    = ""
}
