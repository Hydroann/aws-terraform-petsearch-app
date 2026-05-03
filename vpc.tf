
resource "aws_vpc" "petsearch" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "petsearch-vpc"
  }
}

resource "aws_subnet" "public_petsearch_subnet_1" {
  vpc_id                  = aws_vpc.petsearch.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-petsearch-subnet-1"
  }
}

resource "aws_subnet" "public_petsearch_subnet_2" {
  vpc_id                  = aws_vpc.petsearch.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-petsearch-subnet-2"
  }
}

resource "aws_subnet" "private_petsearch_subnet_1" {
  vpc_id                  = aws_vpc.petsearch.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-west-2c"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-petsearch-subnet-1"
  }
}

resource "aws_subnet" "private_petsearch_subnet_2" {
  vpc_id                  = aws_vpc.petsearch.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-west-2d"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-petsearch-subnet-2"
  }
}
