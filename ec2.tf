resource "aws_instance" "petsearch_wordpress_server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet_petsearch_1
  vpc_security_group_ids      = [aws_security_group.petsearch_sg]
  associate_public_ip_address = true
  key_name                    = var.key_name
  user_data                   = file("scripts/userdata.sh")

  tags = {
    Name = "petseach-wordpress-server"
  }
}
resource "aws_instance" "bastion-instance" {
  ami                         = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  instance_type               = var.instance_type
  associate_public_ip_address = true
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public_subnet_petsearch_1
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "bastion-instance"
  }
}
