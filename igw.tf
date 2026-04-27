resource "aws_internet_gateway" "petsearch-igw" {
  vpc_id = aws_vpc.petsearch.id

  tags = {
    Name = "petsearch-igw"
  }
}