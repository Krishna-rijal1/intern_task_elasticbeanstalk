//creating vpc 
resource "aws_vpc" "krishna" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
}

//creating internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.krishna.id
}

//creating subnets
resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.krishna.id
  cidr_block        = var.subnet1_cidr
  availability_zone = var.region
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.krishna.id
  cidr_block        = var.subnet2_cidr
  availability_zone = var.region2
  map_public_ip_on_launch = true
}

//route table and association
resource "aws_route_table" "subnet1_route_table" {
  vpc_id = aws_vpc.krishna.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}
//subnet association
resource "aws_route_table_association" "subnet1_subnet_association" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.subnet1_route_table.id
}

resource "aws_route_table" "subnet2_route_table" {
  vpc_id = aws_vpc.krishna.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}


resource "aws_route_table_association" "subnet2_subnet_association" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.subnet2_route_table.id
}

resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.krishna.id
  //Inbound rule for SSH (for instance in the private subnet)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  //Inbound rule for HTTP traffic (for instance in the public subnet)
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
  //https
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}