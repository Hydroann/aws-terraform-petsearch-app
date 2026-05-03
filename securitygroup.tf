#petsearch_web_sg
resource "aws_security_group" "petsearch_web_sg" {
  name        = "petsearch_web_sg"
  description = "Allow HTTP from ALB only, SSH from Bastion Host and allow all outbound traffic"
  vpc_id      = aws_vpc.petsearch.id

  tags = {
    Name = "petsearch_web_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "petsearch_web_sg_allow_http_from_alb" {
  security_group_id  = [aws_security_group.petsearch_alb_sg.id]
  cidr_ipv4 = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "petsearch_web_sg_allow_ssh_from_bastion_host" {
  security_group_id  = [aws_security_group.bastion_sg.id]
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "petsearch_web_sg_allow_all_outbound" {
  security_group_id  = aws_security_group.petsearch_web_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
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
  cidr_ipv4.        = [var.my_ip]
}

resource "aws_vpc_security_group_egress_rule" "bastion_sg_allow_all_outbound" {
  security_group_id = aws_security_group.bastion_sg
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 

}



#rds_sg
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow MySQL from webserver and allow all outbound traffic"
  vpc_id      = aws_vpc.petsearch.id  
 
  tags = {
    Name = "rds_sg"
  }
}

resource "aws_security_group_ingress_rule" "rds_sg_allow_mysql_from_webserver" {
    security_group_id = [aws_security_group.petsearch_web_sg.id]
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
}
resource "aws_security_group_egress_rule" "rds_sg_allow_all_outbound" {
    security_group_id = aws_security_group.rds_sg.id
    cidr_ipv4 ="0.0.0.0/0"
    ip_protocol  = "-1"
    
}




#alb_sg
resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Allow HTTP from the internet to the load balancer"
  vpc_id      = aws_vpc.main.id
 
  tags = { 
    Name = "alb_sg" 
    }
}

resource "aws_vpc_security_group_ingress_rule" "alb_sg_allow_http_from_internet" {
    security_group_id = aws_security_group.alb_sg.id
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr_ipv4   = "0.0.0.0/0"
  }

resource "aws_vpc_security_group_egress_rule" "alb_sg_allow_all_outbound" {
    security_group_id = aws_security_group.alb_sg.id
    cidr_ipv4         = "0.0.0.0/0"
    ip_protocol       = "-1" 
  }

  
