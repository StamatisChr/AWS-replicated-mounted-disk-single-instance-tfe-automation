#!/bin/bash
apt update
apt install -y docker.io  docker-buildx
usermod -a -G docker ubuntu 
curl -o /tmp/install.sh https://install.terraform.io/ptfe/stable