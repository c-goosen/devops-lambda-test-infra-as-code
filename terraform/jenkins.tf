# Configure the AWS Provider
provider "aws" {
  version = "~> 2.0"
  region  = "eu-west-1"
}

# # variable "vpc_main_id" {
#   id = "vpc-fa73239f"
# }


locals {
  vpc_main_id        = "vpc-fa73239f"
}

# Create a VPC
# resource "aws_vpc" "goose_main" {
#   cidr_block = "10.0.0.0/16"
#   enable_dns_support = true
#   enable_dns_hostnames  = true
# }

# data "aws_vpc" "goose_main" {
#   id = "vpc-fa73239f"
# }

resource "aws_subnet" "jenkins_subnet" {
  vpc_id     = "${local.vpc_main_id}"
  cidr_block = "172.31.15.0/24"
  availability_zone= "eu-west-1a"

  tags = {
    Name = "jenkins_subnet"
  }
}

resource "aws_security_group" "allow_jenkins_ssh" {
name        = "allow_jenkins_ssh"
description = "Allow SSH inbound traffic"
vpc_id      = "${local.vpc_main_id}"

ingress {
  # TLS (change to whatever ports you need)
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  # Please restrict your ingress to only necessary IPs and ports.
  # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
  cidr_blocks = ["0.0.0.0/0"]
}

egress {
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  cidr_blocks     = ["0.0.0.0/0"]
  # prefix_list_ids = ["pl-12c4e678"]
}
}

resource "aws_security_group" "allow_jenkins_tls" {
name        = "allow_jenkins_tls"
description = "Allow TLS inbound traffic"
vpc_id      = "${local.vpc_main_id}"

ingress {
  # TLS (change to whatever ports you need)
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  # Please restrict your ingress to only necessary IPs and ports.
  # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
  cidr_blocks = ["0.0.0.0/0"]
}

egress {
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  cidr_blocks     = ["0.0.0.0/0"]
  # prefix_list_ids = ["pl-12c4e678"]
}
}

resource "aws_security_group" "allow_jenkins_http" {
  name        = "allow_jenkins_http"
  description = "Allow http inbound traffic"
  vpc_id      = "${local.vpc_main_id}"

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    # prefix_list_ids = ["pl-12c4e678"]
  }
}

data "aws_ami" "jenkins_ami" {
  most_recent      = true
  owners           = ["self", "955244480243"]

  filter {
    name   = "name"
    values = ["jenkins-ec2-packer*"]
  }

}

resource "aws_instance" "jenkins" {
  ami           = "${data.aws_ami.jenkins_ami.id}"
  # ami = "ami-019d8ccec35de54d8"
  # ami = "ami-02df9ea15c1778c9c"
  instance_type = "t2.small"
  vpc_security_group_ids  = [
    "${aws_security_group.allow_jenkins_http.id}",
    "${aws_security_group.allow_jenkins_ssh.id}",
    "${aws_security_group.allow_jenkins_tls.id}"
    ]
  associate_public_ip_address = true
  subnet_id = "${aws_subnet.jenkins_subnet.id}"
  key_name = "vatGlobal"

  tags = {
    Name = "HelloWorld"
  }
}