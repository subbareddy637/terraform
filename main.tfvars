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

module "vpc" {
    source = "../../../modules/vpc"

    vpc_cidr = "10.0.0.0/16"
}


module "public_subnet" {
    source = "../../../modules/subnets"

    subnet_cidr = ["10.0.1.0/24, 10.0.2.0/24"]
    vpc_id = module.vpc.vpc.vpc_id
    availability_zone = ["us_east-1a, us-east-1b"]
    map_public_ip_on_launch = "true"
    subnet_name = "public"
}

module "private_subnet" {
    source = "../../../modules/subnets"

    subnet_cidr = ["10.0.5.0/24, 10.0.6.0/24"]
    vpc_id = module.vpc.vpc.vpc_id
    availability_zone = ["us_east-1a, us-east-1b"]
    map_public_ip_on_launch = "true"
    subnet_name = "private"
}

module "internet_gateway" {
    source = "../../../modules/internetgateway"

    vpc_id = module.vpc.vpc.id
}


module "security_group" {
    source = "../../../modules/securitygroups"

    name = "security_group"
    descrition = ""
    vpc_id = module.vpc.vpc.id

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
    source = "../../../modules/ec2"

    ec2_count = "2"
    ami = "ami-0742b4e673072066f"
    instance_type = "t2.micro"
    vpc_id = module.vpc.vpc.vpc_id
    subnet_ids = module.public_subnet.subnets.id
    security_group = module.security_group.securitygroups.vpc_id
    ec2_name = "public"
}