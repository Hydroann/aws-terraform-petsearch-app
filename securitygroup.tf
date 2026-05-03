#petsearch_web_sg
resource "aws_security_group" "petsearch-web-sg" {
  name        = "petsearch-web-sg"
  description = "Allow HTTP from ALB only, SSH from Bastion Host and allow all outbound traffic"
  vpc_id      = aws_vpc.petsearch.id

  tags = {
    Name = "petsearch_web_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "petsearch-web-sg-allow-http-from-alb" {
  security_group_id            = aws_security_group.petsearch-web-sg.id
  referenced_security_group_id = aws_security_group.alb-sg.id
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "petsearch-web-sg-allow-ssh-from-bastion-host" {
  security_group_id            = aws_security_group.petsearch-web-sg.id
  referenced_security_group_id  = aws_security_group.bastion-sg.id
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "petsearch-web-sg-allow-all-outbound" {
  security_group_id  = aws_security_group.petsearch-web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}


#bastion_sg
resource "aws_security_group" "bastion-sg" {
  name        = "bastion-sg"
  description = "Allow SSH from my IP and allow all outbound traffic"
  vpc_id      = aws_vpc.petsearch.id

  tags = {
    Name = "bastion_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "bastion-sg-allow-ssh-from-my-ip" {
  security_group_id = aws_security_group.bastion-sg.id
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  cidr_ipv4       = var.my_ip
}

resource "aws_vpc_security_group_egress_rule" "bastion-sg-allow-all-outbound" {
  security_group_id = aws_security_group.bastion-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 

}



#rds_sg
resource "aws_security_group" "rds-sg" {
  name        = "rds-sg"
  description = "Allow MySQL from webserver and allow all outbound traffic"
  vpc_id      = aws_vpc.petsearch.id  
 
  tags = {
    Name = "rds-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "rds-sg-allow-mysql-from-webserver" {
    security_group_id = aws_security_group.petsearch-web-sg.id
    from_port       = 3306
    to_port         = 3306
    ip_protocol     = "tcp"
    cidr_ipv4      = "0.0.0.0/0"
}
resource "aws_vpc_security_group_egress_rule" "rds-sg-allow-all-outbound" {
    security_group_id = aws_security_group.rds-sg.id
    cidr_ipv4 ="0.0.0.0/0"
    ip_protocol  = "-1"
    
}




#alb_sg
resource "aws_security_group" "alb-sg" {
  name        = "alb-sg"
  description = "Allow HTTP from the internet to the load balancer"
  vpc_id      = aws_vpc.petsearch.id
 
  tags = { 
    Name = "alb-sg" 
    }
}

resource "aws_vpc_security_group_ingress_rule" "alb-sg-allow-http-from-internet" {
    security_group_id = aws_security_group.alb-sg.id
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr_ipv4   = "0.0.0.0/0"
  }

resource "aws_vpc_security_group_egress_rule" "alb-sg-allow-all-outbound" {
    security_group_id = aws_security_group.alb-sg.id
    cidr_ipv4         = "0.0.0.0/0"
    ip_protocol       = "-1" 
  }

  
