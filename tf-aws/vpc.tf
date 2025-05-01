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

  tags = {
    Name = "test-web-subnet"
  }
}
