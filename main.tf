# Creation of VPC
resource "aws_vpc" "my-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    "Name" = "my-homework-vpc"
  }
}

# Creation of 2 private subnets private-1a and private-1b 
resource "aws_subnet" "private-1a" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    "Name" = "Application-private-1a"
  }

}
resource "aws_subnet" "private-1b" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "eu-west-1b"
  tags = {
    "Name" = "Application-private-1b"
  }
}

# Creation of 2 private subnets public-1a and public-1b 

resource "aws_subnet" "public-1a" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    "Name" = "Application-public-1a"
  }
  depends_on = [
    aws_vpc.my-vpc,
    aws_internet_gateway.my-vpc-igw
  ]
}

resource "aws_subnet" "public-1b" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-1b"
  tags = {
    "Name" = "Application-public-1b"
  }
  depends_on = [
    aws_vpc.my-vpc,
    aws_internet_gateway.my-vpc-igw
  ]
}

# Creation of IGW for accessing the internet

resource "aws_internet_gateway" "my-vpc-igw" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    "Name" = "my-application-gateway"
  }
  depends_on = [
    aws_vpc.my-vpc
  ]
}

# Creation of IGW routing table

resource "aws_route" "internet-route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.my-vpc-rt.id
  gateway_id             = aws_internet_gateway.my-vpc-igw.id
}

# Creation of public route tables and associations

resource "aws_route_table" "my-vpc-rt" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    "Name" = "my-app-route-table"
  }
  depends_on = [
    aws_vpc.my-vpc,
    aws_internet_gateway.my-vpc-igw,
    aws_subnet.public-1a,
    aws_subnet.public-1b
  ]
}

resource "aws_route_table_association" "public-1a" {
  subnet_id      = aws_subnet.public-1a.id
  route_table_id = aws_route_table.my-vpc-rt.id
}

resource "aws_route_table_association" "public-1b" {
  subnet_id      = aws_subnet.public-1b.id
  route_table_id = aws_route_table.my-vpc-rt.id
}

# Creation of 2 Elastic IPs for each public subnet
resource "aws_eip" "tfeip-1" {
  vpc = true
  tags = {
    Name = "my-tf-eip-1"
  }
  depends_on = [
    aws_route_table_association.public-1a
  ]
}

resource "aws_eip" "tfeip-2" {
  vpc = true
  tags = {
    Name = "my-tf-eip-2"
  }
  depends_on = [
    aws_route_table_association.public-1b
  ]
}

# Creation of NAT gateways of both public subnets

resource "aws_nat_gateway" "tf-nat-1a" {
  allocation_id = aws_eip.tfeip-1.id
  subnet_id     = aws_subnet.public-1a.id
  tags = {
    Name = "tf-nat-gateway-1a"
  }
  depends_on = [
    aws_eip.tfeip-1
  ]
}

resource "aws_nat_gateway" "tf-nat-1b" {
  allocation_id = aws_eip.tfeip-2.id
  subnet_id     = aws_subnet.public-1b.id
  tags = {
    Name = "tf-nat-gateway-1b"
  }
  depends_on = [
    aws_eip.tfeip-2
  ]
}

# Creation of private route tables

resource "aws_route_table" "tf-private-route-1a" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.tf-nat-1a.id
  }
  tags = {
    Name        = "tf-private-route-table-1a"
    description = "Route table for egress traffic in private subnet"
  }
  depends_on = [
    aws_nat_gateway.tf-nat-1a
  ]
}

resource "aws_route_table" "tf-private-route-1b" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.tf-nat-1b.id
  }
  tags = {
    Name        = "tf-private-route-table-1b"
    description = "Route table for egress traffic in private subnet"
  }
  depends_on = [
    aws_nat_gateway.tf-nat-1b
  ]
}

# Association of private routes with Nat gateways ofr internet access

resource "aws_route_table_association" "private-1a" {
  subnet_id      = aws_subnet.private-1a.id
  route_table_id = aws_route_table.tf-private-route-1a.id
}
resource "aws_route_table_association" "private-1b" {
  subnet_id      = aws_subnet.private-1b.id
  route_table_id = aws_route_table.tf-private-route-1b.id
  depends_on = [
    aws_route_table.tf-private-route-1b
  ]
}

# Creation of DynamoDB for locking

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "dynamodb-state-locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
