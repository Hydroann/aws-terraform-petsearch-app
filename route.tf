#public route table
resource "aws_route_table" "public_petsearch_rtb" {
    vpc_id = aws_vpc.petsearch.id
    route {
        cidr_block = "0.0.0.0/0"        
        gateway_id = aws_internet_gateway.petsearch-igw.id
    }
    tags = {
        Name = "public-petsearch-route-table"
    }
}       
resource "aws_route_table_association" "public_petsearch_rtb_association_1" {
  subnet_id      = aws_subnet.public_petsearch_subnet_1.id
  route_table_id = aws_route_table.public_petsearch_rtb.id
}

resource "aws_route_table_association" "public_petsearch_rtb_association_2" {
  subnet_id      = aws_subnet.public_petsearch_subnet_2.id
  route_table_id = aws_route_table.public_petsearch_rtb.id
}


#private route table
resource "aws_route_table" "private_petsearch_rtb" {
    vpc_id = aws_vpc.petsearch.id
    
    tags = {
        Name = "private-petsearch-route-table"
    }
}       
resource "aws_route_table_association" "private_petsearch_rtb_association_1" {
  subnet_id      = aws_subnet.private_petsearch_subnet_1.id
  route_table_id = aws_route_table.private_petsearch_rtb.id
}
resource "aws_route_table_association" "private_petsearch_rtb_association_2" {
  subnet_id      = aws_subnet.private_petsearch_subnet_2
  route_table_id = aws_route_table.private_petsearch_rtb.id
}