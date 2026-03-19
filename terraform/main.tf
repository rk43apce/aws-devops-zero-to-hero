provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "web_sg" {
  name = "web_sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_instance" "app_server" {
  ami           = "ami-0f58b397bc5c1f2e8" # Amazon Linux (update if needed)
  instance_type = "t2.micro"

  security_groups = [aws_security_group.web_sg.name]

  key_name = var.key_name

  user_data = <<-EOF
            #!/bin/bash
            apt-get update -y
            apt-get install -y docker.io
            systemctl start docker
            systemctl enable docker
            usermod -aG docker ubuntu
            EOF

  tags = {
    Name = "cicd-demo"
  }
}