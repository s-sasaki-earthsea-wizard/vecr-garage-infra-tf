# Data source to get the latest Ubuntu 22.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security group for EC2 instances
resource "aws_security_group" "ec2_sg" {
  name        = "${var.project}-${var.environment}-ec2-sg"
  description = "Security group for ${var.project} EC2 instances"
  vpc_id      = var.vpc_id

  # SSH access from anywhere (you might want to restrict this in production)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_allowed_cidr_blocks
    description = "SSH access"
  }

  # Outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = "${var.project}-${var.environment}-ec2-sg"
    Environment = var.environment
    Project     = var.project
  }
}

# EC2 instance
resource "aws_instance" "app_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  subnet_id              = var.subnet_id
  iam_instance_profile   = var.iam_instance_profile_name

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
    delete_on_termination = true
    encrypted             = true
  }

  user_data = <<-EOF
    #!/bin/bash
    echo "Setting up ${var.project} application server for ${var.environment} environment"
    
    # Update system and apply all updates
    apt-get update
    apt-get upgrade -y
    
    # Install required packages
    apt-get install -y \
      awscli \
      jq \
      git \
      curl \
      wget \
      make \
      vim \
      net-tools \
      dnsutils
    
    # Setup application directory
    mkdir -p /opt/${var.project}
    
    # Add more setup steps as needed
  EOF

  tags = {
    Name        = "${var.project}-${var.environment}-app-server"
    Environment = var.environment
    Project     = var.project
  }

  monitoring = var.detailed_monitoring_enabled

  lifecycle {
    create_before_destroy = true
  }
}

# Elastic IP for the EC2 instance (optional)
resource "aws_eip" "app_server" {
  count    = var.create_elastic_ip ? 1 : 0
  domain   = "vpc"
  instance = aws_instance.app_server.id
  
  tags = {
    Name        = "${var.project}-${var.environment}-app-server-eip"
    Environment = var.environment
    Project     = var.project
  }
}

# Outputs
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.app_server.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = var.create_elastic_ip ? aws_eip.app_server[0].public_ip : aws_instance.app_server.public_ip
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.ec2_sg.id
}