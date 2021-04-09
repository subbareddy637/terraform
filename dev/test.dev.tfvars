vpc_cidr = "10.0.0.0/16"

public_subnet_cidr = ["10.0.1.0/24, 10.0.2.0/24"]
public_availability_zone = ["us_east-1a, us-east-1b"]
public_subnet_name = "public"


private_subnet_cidr = ["10.0.5.0/24, 10.0.6.0/24"]
private_availability_zone = ["us_east-1a, us-east-1b"]
private_subnet_name = "private"


sg_name = "security_group"
description = ""


instance_count = "2"
ami = "ami-0742b4e673072066f"
instance_type = "t2.micro"
ec2_name = "public"