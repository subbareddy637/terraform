resource "aws_subnet" "subnet" {
  count = length(var.subnet_cidr)  
  vpc_id     = var.vpc_id
  cidr_block = element(var.subnet_cidr, count.index)
  availability_zone = element(var.availability_zone, count.index)
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name = "${var.subnet_name}-subnet-${count.index}"
  }
}