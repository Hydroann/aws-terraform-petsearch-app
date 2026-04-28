#petsearch_sg
resource "aws_security_group" "petsearch_sg" {
  name        = "petsearch_sg"
  description = "Allow HTTP HTTPS from web, SSH from Bastion Host and allow all outbound traffic"
  vpc_id      = aws_vpc.petsearch.id

  tags = {
    Name = "petsearch_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "petsearch_sg_allow_https" {
  security_group_id = aws_security_group.petsearch_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "petsearch_sg_allow_http" {
  security_group_id = aws_security_group.petsearch_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

#resource "aws_vpc_security_group_ingress_rule" "allow_shh_from_bastion_host" {
 # security_group_id = aws_security_group.bastion_sg.id
 # from_port         = 22
  #ip_protocol       = "tcp"
  #to_port           = 22
#}

resource "aws_vpc_security_group_egress_rule" "petsearch_sg_allow_all_outbound" {
  security_group_id = aws_security_group.petsearch_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

#bastion_sg
resource "aws_security_group" "bastion_sg" {
  name        = "bastion_sg"
  description = "Allow SSH from my IP and allow all outbound traffic"
  vpc_id      = aws_vpc.petsearch.id

  tags = {
    Name = "bastion_sg"
  }
}
resource "aws_vpc_security_group_ingress_rule" "bastion_sg_allow_shh_from_my_ip" {
  security_group_id = aws_security_group.bastion_sg.id
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  #cidr_ipv4 =   [var.my_ip]
}

resource "aws_vpc_security_group_egress_rule" "bastion_sg_allow_all_outbound" {
  security_group_id = aws_security_group.bastion_sg
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}