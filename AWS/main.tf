terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "tfe-instance" {
    ami = data.aws_ami.ubuntu_2404.id
    instance_type = var.tfe_instance_type
    
}

