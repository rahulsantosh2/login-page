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

#api subnet route table association
resource "aws_route_table_association" "test-api-assc" {
  subnet_id      = aws_subnet.test-api-sn.id
  route_table_id = aws_route_table.test-pub-rt.id
}


#private route-table
resource "aws_route_table" "test-pvt-rt" {
  vpc_id = aws_vpc.test.id

  tags = {
    Name = "test-pvt-rt"
  }
}

#db subnet route table association
resource "aws_route_table_association" "test-db-assc" {
  subnet_id      = aws_subnet.test-db-sn.id
  route_table_id = aws_route_table.test-pvt-rt.id
}


#creating nacl
resource "aws_network_acl" "test-nacl" {
  vpc_id = aws_vpc.test.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "test-nacl"
  }
}

#nacl web association
resource "aws_network_acl_association" "test-nacl-web-assc" {
  network_acl_id = aws_network_acl.test-nacl.id
  subnet_id      = aws_subnet.test-web-sn.id
}


#nacl api association
resource "aws_network_acl_association" "test-nacl-api-assc" {
  network_acl_id = aws_network_acl.test-nacl.id
  subnet_id      = aws_subnet.test-api-sn.id
}


#nacl db association
resource "aws_network_acl_association" "test-nacl-db-assc" {
  network_acl_id = aws_network_acl.test-nacl.id
  subnet_id      = aws_subnet.test-db-sn.id
}


#web security groups
resource "aws_security_group" "web-sg" {
  name        = "web-sg"
  description = "Allow Web Traffic"
  vpc_id      = aws_vpc.test.id

  tags = {
    Name = "web-sg"
  }
}


#web sg rules - ingress rule - ssh
resource "aws_vpc_security_group_ingress_rule" "web-sg-ssh" {
  security_group_id = aws_security_group.web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

#web sg rules - ingress rule - http
resource "aws_vpc_security_group_ingress_rule" "web-sg-http" {
  security_group_id = aws_security_group.web-sg.id
  cidr_ipv4          = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

#web sg rules - egress rule - all
resource "aws_vpc_security_group_egress_rule" "web-sg-all" {
  security_group_id = aws_security_group.web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}



#api security groups
resource "aws_security_group" "api-sg" {
  name        = "api-sg"
  description = "Allow Web Traffic"
  vpc_id      = aws_vpc.test.id

  tags = {
    Name = "api-sg"
  }
}


#api sg rules - ingress rule - ssh
resource "aws_vpc_security_group_ingress_rule" "api-sg-ssh" {
  security_group_id = aws_security_group.api-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

#api sg rules - ingress rule - http
resource "aws_vpc_security_group_ingress_rule" "api-sg-http" {
  security_group_id = aws_security_group.api-sg.id
  cidr_ipv4          = "0.0.0.0/0"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}

#api sg rules - egress rule - all
resource "aws_vpc_security_group_egress_rule" "api-sg-all" {
  security_group_id = aws_security_group.api-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}



#db security groups
resource "aws_security_group" "db-sg" {
  name        = "db-sg"
  description = "Allow Web Traffic"
  vpc_id      = aws_vpc.test.id

  tags = {
    Name = "db-sg"
  }
}


#db sg rules - ingress rule - ssh
resource "aws_vpc_security_group_ingress_rule" "db-sg-ssh" {
  security_group_id = aws_security_group.db-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

#db sg rules - ingress rule - http
resource "aws_vpc_security_group_ingress_rule" "db-sg-http" {
  security_group_id = aws_security_group.db-sg.id
  cidr_ipv4          = "0.0.0.0/0"
  from_port         = 5432
  ip_protocol       = "tcp"
  to_port           = 5432
}

#db sg rules - egress rule - all
resource "aws_vpc_security_group_egress_rule" "db-sg-all" {
  security_group_id = aws_security_group.db-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}







#aws ec2 web instance server
resource "aws_instance" "test-server" {
  ami           = "ami-0f9de6e2d2f067fca"
  instance_type = "t2.micro"
  key_name      = "test_key"
  subnet_id     = aws_subnet.test-web-sn.id
  vpc_security_group_ids = [aws_security_group.web-sg.id]

  tags = {
    Name = "test-server"
  }
}

