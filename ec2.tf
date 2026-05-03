resource "aws_instance" "petsearch_webserver" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public-petsearch-subnet-1.id
  vpc_security_group_ids      = [aws_security_group.petsearch-web-sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_name
  user_data                   = file("scripts/userdata.sh")

  tags = {
    Name = "petsearch-webserver"
  }
}
resource "aws_instance" "bastion-instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  associate_public_ip_address = true
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public-petsearch-subnet-1.id
  vpc_security_group_ids      = [aws_security_group.bastion-sg.id]

  tags = {
    Name = "bastion-instance"
  }
}
