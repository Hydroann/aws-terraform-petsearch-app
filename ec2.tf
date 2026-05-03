resource "aws_instance" "petsearch_webserver" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = [aws_subnet.public_petsearch_subnet_1]
  vpc_security_group_ids      = [aws_security_group.petsearch_web_sg]
  associate_public_ip_address = true
  key_name                    = var.key_name
  user_data                   = file("scripts/userdata.sh")

  tags = {
    Name = "petsearch-webserver"
  }
}
resource "aws_instance" "bastion-instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  key_name                    = var.key_name
  subnet_id                   = [aws_subnet.public_petsearch_subnet_1]
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "bastion-instance"
  }
}
