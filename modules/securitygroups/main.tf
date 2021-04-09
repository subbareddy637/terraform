 resource "aws_security_group" "security_groups" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id
  
  dynamic "ingress" {
    for_each = var.sg_ingress
    content {
      cidr_blocks      = ingress.value["cidr_blocks"]
      description      = ingress.value["description"]
      from_port        = ingress.value["from_port"]
      to_port          = ingress.value["to_port"]
      protocol         = ingress.value["protocol"]
    }
  }

  dynamic "egress" {
    for_each = var.sg_egress
    content {
      cidr_blocks      = egress.value["cidr_blocks"]
      description      = egress.value["description"]
      from_port        = egress.value["from_port"]
      to_port          = egress.value["to_port"]
      protocol         = egress.value["protocol"]
    }
  }

}