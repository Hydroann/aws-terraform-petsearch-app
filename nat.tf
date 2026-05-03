resource "aws_eip" "nat" {
  domain = "vpc"

  # Must wait until the Internet Gateway exists before creating this
  depends_on = [aws_internet_gateway.petsearch-igw]

  tags = {
    Name = "petsearch-nat-eip"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-petsearch-subnet-1.id # NAT Gateway lives in a public subnet

  depends_on = [aws_internet_gateway.petsearch-igw]

  tags = {
    Name = "petsearch-nat-gw"
  }
}