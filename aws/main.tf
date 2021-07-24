terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  # <PROVIDER>_<TYPE>.<NAME>.<ATTRIBUTE>
  vpc_security_group_ids = [aws_security_group.allow_8080.id]
  user_data              = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
  tags = {
    Name = "CheapWorker"
  }
}

resource "aws_security_group" "allow_8080" {
  name        = "allow_8080"
  description = "Allow inbound traffic to port 8080"

  ingress {
    description = "custom http port"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
