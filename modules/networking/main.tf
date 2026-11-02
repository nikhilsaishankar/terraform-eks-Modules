resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true 
    enable_dns_hostnames = true 
    tags = {
        Name = "myvpc"
    }
    instance_tenancy = "default"
}

resource "aws_subnet" "subnet" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "Publicsubnet1"
    }
    availability_zone = "us-east-1a"
    cidr_block = "10.0.0.0/24"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet2" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "Publicsubnet2"
    }
    availability_zone = "us-east-1b"
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "aig" {
    tags = {
        Name = "DIGW"
    }
    vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "route1" {
    tags = {
        Name = "Publicmyroutetable"
    }
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.aig.id
    }
}

resource "aws_route_table_association" "ast1" {
  route_table_id = aws_route_table.route1.id
  subnet_id      = aws_subnet.subnet.id
}

resource "aws_route_table_association" "ast3" {
  route_table_id = aws_route_table.route1.id
  subnet_id      = aws_subnet.subnet2.id
}


resource "aws_security_group" "mysg" {
    name = "my-security-group"
    description = "Allow SSH and HTTP"
    vpc_id = aws_vpc.vpc.id

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
     egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}