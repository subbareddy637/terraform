module "vpc" {
    source = "../modules/vpc"

    vpc_cidr = "10.0.0.0/16"
}


module "public_subnet" {
    source = "../modules/subnets"

    subnet_cidr = ["10.0.1.0/24, 10.0.2.0/24"]
    vpc_id = module.vpc.vpc.vpc_id
    availability_zone = ["us_east-1a, us-east-1b"]
    map_public_ip_on_launch = "true"
    subnet_name = "public"
}

module "private_subnet" {
    source = "../modules/subnets"

    subnet_cidr = ["10.0.5.0/24, 10.0.6.0/24"]
    vpc_id = module.vpc.vpc.vpc_id
    availability_zone = ["us_east-1a, us-east-1b"]
    map_public_ip_on_launch = "true"
    subnet_name = "private"
}

module "internet_gateway" {
    source = "../modules/internetgateway"

    vpc_id = module.vpc.vpc.id
}

module "ec2_instance" {
    source = "../modules/ec2"

    ec2_count = "2"
    ami = "ami-0742b4e673072066f"
    instance_type = "t2.micro"
    vpc_id = module.vpc.vpc.vpc_id
    subnet_ids = module.public_subnet.subnets.id
    security_group = module.security_group.securitygroups.vpc_id
    ec2_name = "public"
}