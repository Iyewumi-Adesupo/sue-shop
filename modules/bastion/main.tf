resource "aws_instance" "bastion" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [var.bastion_sg_id]

  associate_public_ip_address = true

  tags = {
    Name        = "sueshop-bastion"
    Role        = "bastion"
    Environment = var.environment
  }
}