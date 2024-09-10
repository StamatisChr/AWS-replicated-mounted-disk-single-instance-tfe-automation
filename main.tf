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

resource "aws_instance" "tfe_instance" {
  ami             = data.aws_ami.ubuntu_2404.id
  instance_type   = var.tfe_instance_type
  key_name        = var.my_key_name # the key is region specific
  user_data       = templatefile("user-data.sh", {})
  security_groups = [aws_security_group.tfe_sg.name]
  ebs_optimized   = true
  root_block_device {
    volume_size = 120
    volume_type = "gp3"

  }

  tags = {
    Name = "stam-tfe-instance"
  }

}

# Security group for TFE. Ports needed: https://developer.hashicorp.com/terraform/enterprise/replicated/requirements/network
resource "aws_security_group" "tfe_sg" {
  name        = "tfe_sg"
  description = "Allow inbound traffic and outbound traffic for TFE"

  tags = {
    Name = "tfe_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.tfe_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.tfe_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_replicated" {
  security_group_id = aws_security_group.tfe_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8800
  ip_protocol       = "tcp"
  to_port           = 8800
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.tfe_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_traffic_ipv4" {
  security_group_id = aws_security_group.tfe_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


resource "aws_route53_record" "tfe-a-record" {
  zone_id = var.my_hosted_zone_id
  name    = var.my_tfe_dns_record
  type    = "A"
  ttl     = 120
  records = [aws_instance.tfe_instance.public_ip]
}