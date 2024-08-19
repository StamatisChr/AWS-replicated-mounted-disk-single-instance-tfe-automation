output "ubuntu_ami_id" {
    value = data.aws_ami.ubuntu.id
  
}

output "ubuntu_ami_name" {
    value = data.aws_ami.ubuntu.name
  
}

output "aws_region" {
    value = var.aws_region
  
}

output "ubuntu_ami_description" {
    value = data.aws_ami.ubuntu.description
  
}

