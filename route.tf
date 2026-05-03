#public route table
resource "aws_route_table" "public-petsearch_rtb" {
    vpc_id = aws_vpc.petsearch.id
    route {
        cidr_block = "0.0.0.0/0"        
        gateway_id = aws_internet_gateway.petsearch-igw.id
    }
    tags = {
        Name = "public-petsearch-route-table"
    }
}       
resource "aws_route_table_association" "public-petsearch-rtb-association_1" {
  subnet_id      = aws_subnet.public-petsearch-subnet_1.id
  route_table_id = aws_route_table.public-petsearch-rtb.id
}

resource "aws_route_table_association" "public-petsearch-rtb-association_2" {
  subnet_id      = aws_subnet.public-petsearch-subnet_2.id
  route_table_id = aws_route_table.public-petsearch-rtb.id
}


#private route table
resource "aws_route_table" "private-petsearch-rtb" {
    vpc_id = aws_vpc.petsearch.id
    
    tags = {
        Name = "private-petsearch-route-table"
    }
}       
resource "aws_route_table_association" "private-petsearch-rtb-association-1" {
  subnet_id      = aws_subnet.private-petsearch-subnet-1.id
  route_table_id = aws_route_table.private-petsearch-rtb.id
}
resource "aws_route_table_association" "private-petsearch-rtb-association-2" {
  subnet_id      = aws_subnet.private-petsearch-subnet-2.id
  route_table_id = aws_route_table.private-petsearch_rtb.id
}