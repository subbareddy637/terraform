resource "aws_instance" "ec2" {
  count = var.ec2_count
  ami   = var.ami
  instance_type = var.instance_type
  vpc_id = var.vpc_id
  subnet_id = (count.index % 2) == 0 ? var.subnet_ids[0] : var.subnet_ids[1]
  security_group_ids = var.security_group
  key_name = var.key_name

  tags = {
    Name = "${var.ec2_name}-${count.index}"
  }
}