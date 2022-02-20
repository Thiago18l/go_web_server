provider "aws" {
  region = local.region
}

locals {
  name   = "ec2-go-web-server"
  region = var.region

}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  associate_public_ip_address = true
  user_data                   = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install ca-certificates \
    curl \
    gnupg \
    lsb-release

    curl -fsSL https://get.docker.io/ | sudo bash

    sudo docker pull ${var.image_name}:${var.commit}
    sudo docker run -d -it -p 8080:${var.app_port} ${var.image_name}:${var.commit} &
    EOF
  vpc_security_group_ids      = ["${aws_security_group.sg-ec2.id}"]
}