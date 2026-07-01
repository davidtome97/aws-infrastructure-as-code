resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "devops-lab-vpc"
    Environment = "dev"
    Project     = "aws-infrastructure-as-code"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "devops-lab-public-subnet"
    Environment = "dev"
    Project     = "aws-infrastructure-as-code"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "devops-lab-igw"
    Environment = "dev"
    Project     = "aws-infrastructure-as-code"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "devops-lab-public-rt"
    Environment = "dev"
    Project     = "aws-infrastructure-as-code"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "web" {
  name        = "devops-lab-web-sg"
  description = "Allow HTTP and SSH inbound traffic for lab purposes"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH from anywhere for lab purposes"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    # In production, restrict SSH access to a trusted IP range.
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "devops-lab-web-sg"
    Environment = "dev"
    Project     = "aws-infrastructure-as-code"
  }
}

resource "aws_instance" "web" {
  ami                         = "ami-0c1c30571d2dae5c9"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true
  user_data_replace_on_change = true

  user_data = <<-EOF
            #!/bin/bash

            apt-get update -y
            apt-get install -y nginx

            systemctl enable nginx
            systemctl start nginx

            cat > /var/www/html/index.html <<HTML
            <!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="UTF-8">
                <title>AWS Infrastructure as Code</title>
            </head>
            <body>
                <h1>Terraform AWS Infrastructure Lab</h1>
                <p>Infrastructure provisioned automatically with Terraform.</p>
                <p><strong>Author:</strong> David Tomé Arnaiz</p>
                <p>AWS • Terraform • EC2 • Nginx</p>
            </body>
            </html>
            HTML
            EOF

  tags = {
    Name        = "devops-lab-ec2"
    Environment = "dev"
    Project     = "aws-infrastructure-as-code"
  }
}