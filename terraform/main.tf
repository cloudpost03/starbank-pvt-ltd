resource "aws_instance" "Master3" {
  ami           = "ami-00bb6a80f01f03502"
  instance_type = "t2.medium"
  key_name      = "MUMBAI"
  tags = {
    Name = "Machine -3"
  }
}

resource "aws_instance" "K8s-Master" {
  ami           = "ami-00bb6a80f01f03502"
  instance_type = "t2.micro"
  key_name      = "MUMBAI"
  tags = {
    Name = "Machine -1"
  }
}

resource "aws_instance" "K8s-Slave1" {
  ami           = "ami-00bb6a80f01f03502"
  instance_type = "t2.micro"
  key_name      = "MUMBAI"
  tags = {
    Name = "Machine -2"
  }
}

# Security Group
resource "aws_security_group" "devops_sg" {
  name        = "default"
  description = "Allow SSH, HTTP, and monitoring ports"

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
