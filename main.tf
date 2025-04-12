# ---------------------------
# VPC A (10.1.0.0/16) - PRIMARY VPC
# ---------------------------
resource "aws_vpc" "vpc_a" {
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "${var.local_prefix}-VPC-A"
  }
}

# Public Subnet in VPC A
resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.vpc_a.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "${var.local_prefix}-public-subnet-a"
  }
}

# Private Subnet in VPC A
resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.vpc_a.id
  cidr_block        = "10.1.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "${var.local_prefix}-private-subnet-a"
  }
}

# # Internet Gateway for VPC A
# resource "aws_internet_gateway" "igw_a" {
#   vpc_id = aws_vpc.vpc_a.id

#   tags = {
#     Name = "${var.local_prefix}-igw-a"
#   }
# }

# Public Route Table for VPC A
# resource "aws_route_table" "public_rt_a" {
#   vpc_id = aws_vpc.vpc_a.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw_a.id
#   }

#   tags = {
#     Name = "${var.local_prefix}-public-rt-a"
#   }
# }

# # Associate Public Subnet A with Route Table
# resource "aws_route_table_association" "rt_assoc_a" {
#   subnet_id      = aws_subnet.public_subnet_a.id
#   route_table_id = aws_route_table.public_rt_a.id
# }

# ---------------------------
# VPC B (10.2.0.0/16) - SECONDARY VPC
# ---------------------------

# resource "aws_vpc" "vpc_b" {
#   cidr_block = "10.2.0.0/16"

#   tags = {
#     Name = "${var.local_prefix}-VPC-B"
#   }
# }

# # Public Subnet in VPC B
# resource "aws_subnet" "public_subnet_b" {
#   vpc_id                  = aws_vpc.vpc_b.id
#   cidr_block              = "10.2.1.0/24"
#   map_public_ip_on_launch = true
#   availability_zone       = "us-east-1a"

#   tags = {
#     Name = "${var.local_prefix}-public-subnet-b"
#   }
# }

# # Private Subnet in VPC B
# resource "aws_subnet" "private_subnet_b" {
#   vpc_id            = aws_vpc.vpc_b.id
#   cidr_block        = "10.2.2.0/24"
#   availability_zone = "us-east-1b"

#   tags = {
#     Name = "${var.local_prefix}-private-subnet-b"
#   }
# }

# Internet Gateway for VPC B
# resource "aws_internet_gateway" "igw_b" {
#   vpc_id = aws_vpc.vpc_b.id

#   tags = {
#     Name = "${var.local_prefix}-igw-b"
#   }
# }

# Public Route Table for VPC B
# resource "aws_route_table" "public_rt_b" {
#   vpc_id = aws_vpc.vpc_b.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw_b.id
#   }

#   tags = {
#     Name = "${var.local_prefix}-public-rt-b"
#   }
# }

# # Associate Public Subnet B with Route Table
# resource "aws_route_table_association" "rt_assoc_b" {
#   subnet_id      = aws_subnet.public_subnet_b.id
#   route_table_id = aws_route_table.public_rt_b.id
# }

# ---------------------------
# Security Group for EC2 in VPC_a
# ---------------------------

resource "aws_security_group" "ec2a_sg" {
  vpc_id = aws_vpc.vpc_a.id  # Attach to VPC A

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict this in production
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.local_prefix}-EC2a-allow-ssh-http"
  }
}

# ---------------------------
# Security Group for EC2 in VPC_b
# ---------------------------

# resource "aws_security_group" "ec2b_sg" {
#   vpc_id = aws_vpc.vpc_b.id  # Attach to VPC B

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]  # Restrict this in production
#   }

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "${var.local_prefix}-EC2b-allow-ssh-http"
#   }
# }


# ---------------------------
# Deploy EC2 in a Public Subnet of VPC_a
# ---------------------------

# resource "aws_instance" "public_ec2-a" {
#   ami                    = data.aws_ami.latest.id
#   instance_type          = var.instance_type
#   subnet_id              = aws_subnet.public_subnet_a.id  # Deploying in VPC A
#   vpc_security_group_ids = [aws_security_group.ec2a_sg.id]
#   associate_public_ip_address = true  # Assign a public IP
#   key_name               = var.key_name  # Change in variable to your key pair name
#   user_data              = templatefile("${path.module}/init-script.sh", {
#    file_content = "${var.local_prefix}-ec2"})

#   tags = {
#     Name = "${var.local_prefix}-EC2-in-VPC-A"
#   }
# }

# ---------------------------
# Deploy EC2 in a Public Subnet of VPC_b
# ---------------------------

# resource "aws_instance" "public_ec2-b" {
#   ami                    = data.aws_ami.latest.id
#   instance_type          = var.instance_type
#   subnet_id              = aws_subnet.public_subnet_b.id  # Deploying in VPC B
#   vpc_security_group_ids = [aws_security_group.ec2b_sg.id]
#   associate_public_ip_address = true  # Assign a public IP
#   key_name               = var.key_name  # Change in variable to your key pair name
#   user_data              = templatefile("${path.module}/init-script.sh", {
#    file_content = "${var.local_prefix}-ec2"})

#   tags = {
#     Name = "${var.local_prefix}-EC2-in-VPC-B"
#   }
# }

output "vpc_a_id" {
  value = aws_vpc.vpc_a.id
}

# output "vpc_b_id" {
#   value = aws_vpc.vpc_b.id
# }

# output "ec2a_sg" {
#   value = aws_instance.public_ec2-a.id
# }

# output "ec2b_sg" {
#   value = aws_instance.public_ec2-b.id
# }