# create vpc
resource "aws_vpc" "test" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "cust_vpc"
    }
  
}
# create subnet
resource "aws_subnet" "test" {
    vpc_id = aws_vpc.test.id
    cidr_block = "10.0.0.0/24"
    tags = {
      Name = "cust_subnet"
    }
  
}
# create ig
resource "aws_internet_gateway" "test" {
    vpc_id = aws_vpc.test.id
    tags = {
      Name = "cust_ig"
    }
  
}
#craete rt
resource "aws_route_table" "test" {
    vpc_id = aws_vpc.test.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.test.id
    }
    tags = {
      Name = "cust_rt"
    }
}
# edit routes
resource "aws_route_table_association" "test" {
    subnet_id = aws_subnet.test.id
    route_table_id = aws_route_table.test.id
    
  
}
#create sg groups
resource "aws_security_group" "allow_tls" {
    vpc_id = aws_vpc.test.id
    tags = {
      Name = "cust_sg"
    }
    ingress {
        description = "Tls from vpc"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
# to createec2
resource "aws_instance" "mad" {
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = aws_subnet.test.id
    security_groups = [aws_security_group.allow_tls.id]
    tags = {
      Name = "raj121"
    }
}
    