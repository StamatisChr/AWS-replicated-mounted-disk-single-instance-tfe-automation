variable "aws_region" {
    description = "The AWS region in use to spawn the resources"
    type = string
}

variable "ubuntu_ami" {
    description = "The ami for the instance creation"
    type = string
}

variable "tfe_instance_type" {
    description = "The ec2 instance typr for TFE"
    type = string
  
}