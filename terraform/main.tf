provider "aws" {
  region = "ap-south-1"
}

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
  default = "assign-key-mumbai"
}

variable "security_group_id" {
  default = "sg-0544446a68f71bb8c"
}

# EC2 Instances
resource "aws_instance" "k8s_master" {
  ami                    = var.ami_id
  instance_type          = var.instance_type_master
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]

  root_block_device {
    volume_size = 20  # 20GB storage for master node
    volume_type = "gp3"
  }

  tags = {
    Name = "K8s-Master"
  }
}

resource "aws_instance" "k8s_slave1" {
  ami                    = var.ami_id
  instance_type          = var.instance_type_worker
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]

  root_block_device {
    volume_size = 10  # 10GB storage for worker node
    volume_type = "gp3"
  }

  tags = {
    Name = "K8s-Slave1"
  }
}

resource "aws_instance" "machine_3" {
  ami                    = var.ami_id
  instance_type          = var.instance_type_worker
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]

  root_block_device {
    volume_size = 10  # 10GB storage for worker node
    volume_type = "gp3"
  }

  tags = {
    Name = "Machine-3"
  }
}
