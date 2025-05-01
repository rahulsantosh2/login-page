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