#aws vpc
resource "aws_vpc" "test" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "test"
  }
}

#web subnet
resource "aws_subnet" "test-web-sn" {
  vpc_id     = aws_vpc.test.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "test-web-subnet"
  }
}


#api subnet
resource "aws_subnet" "test-api-sn" {
  vpc_id     = aws_vpc.test.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "test-api-subnet"
  }
}

#db subnet
resource "aws_subnet" "test-db-sn" {
  vpc_id     = aws_vpc.test.id
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "test-db-subnet"
  }
}

#internet gateway
resource "aws_internet_gateway" "test-igw" {
  vpc_id = aws_vpc.test.id

  tags = {
    Name = "test-igw"
  }
}

#route-table
resource "aws_route_table" "test-pub-rt" {
  vpc_id = aws_vpc.test.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test-igw.id
  }

  tags = {
    Name = "test-public-rt"
  }
}

#web subnet route table association
resource "aws_route_table_association" "test-web-assc" {
  subnet_id      = aws_subnet.test-web-sn.id
  route_table_id = aws_route_table.test-pub-rt.id
}