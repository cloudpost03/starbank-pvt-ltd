provider "aws" {
  region = "ap-south-1" # Mumbai Region
}

# Define Variables
variable "ami_id" {
  default = "ami-00bb6a80f01f03502"
}

variable "instance_type_master" {
  default = "t2.medium"
}

variable "instance_type_worker" {
  default = "t2.medium"
}

variable "key_name" {
  default = "MUMBAI"
}

# Security Group
resource "aws_security_group" "default" {
  name        = "default"
  description = "Allow required ports"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instances
resource "aws_instance" "k8s_master" {
  ami           = var.ami_id
  instance_type = var.instance_type_worker
  key_name      = var.key_name
  security_groups = [aws_security_group.devops_sg.name]

  tags = {
    Name = "K8s-Master"
  }
}

resource "aws_instance" "k8s_slave1" {
  ami           = var.ami_id
  instance_type = var.instance_type_worker
  key_name      = var.key_name
  security_groups = [aws_security_group.devops_sg.name]

  tags = {
    Name = "K8s-Slave1"
  }
}

resource "aws_instance" "machine_3" {
  ami           = var.ami_id
  instance_type = var.instance_type_master
  key_name      = var.key_name
  security_groups = [aws_security_group.devops_sg.name]

  tags = {
    Name = "Machine-3"
  }
}
