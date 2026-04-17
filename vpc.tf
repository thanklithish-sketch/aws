## vpc creation for three tier
resource "aws_vpc" "vpc" {
cidr_block = "172.25.0.0/25"
enable_dns_hostnames = true
enable_dns_support = true
  tags = {
    Name = "project_demo-VPC"
  }
}



# creating subnets part
# public subnet 1
resource "aws_subnet" "public_01" {
  vpc_id     = aws_vpc.vpc.id
  availability_zone = "us-east-1a"
  cidr_block = "172.25.0.0/28"
  tags = {
    Name = "project_public-1"
  }
}
# public subnet 2
resource "aws_subnet" "public_02" {
  vpc_id     = aws_vpc.vpc.id
  availability_zone = "us-east-1b"
  cidr_block = "172.25.0.16/28"
  tags = {
    Name = "project_public-2"
  }
}
# private subnet 1
resource "aws_subnet" "private_01" {
  vpc_id     = aws_vpc.vpc.id
  availability_zone = "us-east-1a"
  cidr_block = "172.25.0.32/28"
  tags = {
    Name = "project_private-1"
  }
}
# private subnet 2
resource "aws_subnet" "private_02" {
  vpc_id     = aws_vpc.vpc.id
  availability_zone = "us-east-1a"
  cidr_block = "172.25.0.48/28"
  tags = {
    Name = "project_private-2"
  }
}
# private subnet 3
resource "aws_subnet" "private_03" {
  vpc_id     = aws_vpc.vpc.id
  availability_zone = "us-east-1b"
  cidr_block = "172.25.0.64/28"
  tags = {
    Name = "project_private-3"
  }
}
# private subnet 4
resource "aws_subnet" "private_04" {
  vpc_id     = aws_vpc.vpc.id
  availability_zone = "us-east-1b"
  cidr_block = "172.25.0.80/28"
  tags = {
    Name = "project_private-4"
  }
}


#route table for public subnet
resource "aws_route_table" "publicroutes" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "project_pub-route"
  }
  }


# private rote table
  resource "aws_route_table" "privroutes" {
  vpc_id = aws_vpc.vpc.id


  route {
    cidr_block = "0.0.0.0/0"
   nat_gateway_id =aws_nat_gateway.nat.id
  }
    tags = {
    Name = "project_priv-route"

  }
}

# internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "project_IG"
  }
}

# nat gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.one.id
  subnet_id     = aws_subnet.public_01.id

  tags = {
    Name = "project_NAT"
  }
  depends_on = [aws_internet_gateway.gw]
}

#eip for nat gateway
resource "aws_eip" "one" {
  domain   = "vpc"
  }


#association for route tables
resource "aws_route_table_association" "pubassoc" {
  for_each = {
  pub1     = aws_subnet.public_01.id
  pub2      = aws_subnet.public_02.id
  }
  subnet_id = each.value

  route_table_id = aws_route_table.publicroutes.id
}
resource "aws_route_table_association" "pri1assoc" {
  for_each = {
  pri1     = aws_subnet.private_01.id
  pri2      = aws_subnet.private_02.id
  pri3    = aws_subnet.private_03.id
  pri4    = aws_subnet.private_04.id
  }
  subnet_id = each.value
  route_table_id = aws_route_table.privroutes.id
  }



