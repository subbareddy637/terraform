terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-west-1"
}

module "VPC" {
    source = "./modules/vpc"

    vpc_cidr = var.vpc_cidr
}


module "public_subnet" {
    source = "./modules/subnets"

    subnet_cidr = var.public_subnet_cidr
    vpc_id = module.VPC.vpc.id
    availability_zone = var.public_availability_zone
    map_public_ip_on_launch = "true"
    subnet_name = var.public_subnet_name
}

module "private_subnet" {
    source = "./modules/subnets"

    subnet_cidr = var.private_subnet_cidr
    vpc_id = module.VPC.vpc.id
    availability_zone = var.private_availability_zone
    map_public_ip_on_launch = "true"
    subnet_name = var.private_subnet_name
}

module "internet_gateway" {
    source = "./modules/internetgateway"

    vpc_id = module.VPC.vpc.id
}


module "security_group" {
    source = "./modules/securitygroups"

    name = var.sg_name
    description = var.description
    vpc_id = module.VPC.vpc.id

    sg_ingress = [
    {
      from_port = 80
      protocol = "tcp"
      to_port = 80
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow web traffic to load balancer"
    },
    {
      from_port   = 8080
      protocol    = "tcp"
      to_port     = 9080
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow web traffic to load balancer"
    },
    {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port       = 22
      to_port         = 22
      protocol        = "tcp"
      cidr_blocks     = ["0.0.0.0/0"]
    }
  ]

  sg_egress = [
    {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}



module "ec2_instance" {
    source = "./modules/ec2"

    ec2_count = var.instance_count
    ami = var.ami
    instance_type = var.instance_type
    vpc_id = module.VPC.vpc.id
    subnet_ids = module.public_subnet.subnets.id
    security_group = module.security_group.securitygroups.id
    key_name = var.key_name
    ec2_name = var.ec2-name
}