##################################################################################
# DATA
##################################################################################

data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}


##################################################################################
# RESOURCES
##################################################################################
# NETWORKING #
resource "aws_default_vpc" "default" {
  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-default-vpc"
  })
}


# For Each with Default Subnet## 
resource "aws_default_subnet" "default_subnet" {
  for_each = toset(local.subnet_azs)

  availability_zone = each.key
}


# Private Subnet for Server Fleet A)Nginx #
resource "aws_subnet" "private_subnets" {
  count             = length(var.vpc_private_subnet_cidr_blocks)
  vpc_id            = aws_default_vpc.default.id
  cidr_block        = element(var.vpc_private_subnet_cidr_blocks, count.index)
  availability_zone = element(local.subnet_azs, count.index)

  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}

# Create EIP for NAT GW1  
resource "aws_eip" "eip_natgw" {
  count = local.eip_count
  vpc   = true
}

# Create NAT gateway
resource "aws_nat_gateway" "natgateway" {
  count = local.eip_count
  allocation_id = element(aws_eip.eip_natgw.*.id, count.index)
  subnet_id     = aws_subnet.private_subnets[count.index].id
}


# Nginx security group 
resource "aws_security_group" "nginx_sg" {
  name   = "${local.name_prefix}-nginx_sg"
  vpc_id = aws_default_vpc.default.id

  # HTTP access from VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.public-alb_sg.id]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

# S3 Bucket config#
resource "aws_iam_role" "allow_nginx_s3" {
  name = "allow_nginx_s3"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = local.common_tags
}

## Instance Profile 
resource "aws_iam_instance_profile" "nginx_profile" {
  name = "nginx_profile"
  role = aws_iam_role.allow_nginx_s3.name

  tags = local.common_tags
}
