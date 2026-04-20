#security group


# for web tier
resource "aws_security_group" "websg" {
  vpc_id = aws_vpc.vpc.id
  description = "for web tier"

tags= {
  Name="web_sg"
}
}
# define outbound rules
resource "aws_vpc_security_group_egress_rule" "websgout" {
  security_group_id = aws_security_group.websg.id

  cidr_ipv4   = "0.0.0.0/0"  //cidr range is used to add the source to add multiple use ["",""] this format
           ip_protocol = "-1"       // -1 refers allow all traffic
    }
  #define inbound rules
resource "aws_vpc_security_group_ingress_rule" "websgin" {
  security_group_id = aws_security_group.websg.id
  cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
  }

# for app tier and db can be updated here
resource "aws_security_group" "appsg" {
    vpc_id = aws_vpc.vpc.id
    description = "for apptier"
  tags = {
    Name="app_sg"
  }
}
resource "aws_vpc_security_group_ingress_rule" "appsgin1" {
  security_group_id = aws_security_group.appsg.id
  cidr_ipv4 = "106.51.1.25/32"
   ip_protocol = "-1"
}
resource "aws_vpc_security_group_ingress_rule" "appsgin2" {
  security_group_id = aws_security_group.appsg.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "icmp"
  from_port = -1
  to_port = -1
}
resource "aws_vpc_security_group_egress_rule" "appsgout" {
    security_group_id = aws_security_group.appsg.id
      ip_protocol = -1
    cidr_ipv4 = "0.0.0.0/0"  
}
#for db tier
resource "aws_security_group" "dbsg" {
    vpc_id = aws_vpc.vpc.id
    description = "for apptier"
  tags = {
    Name="db_sg"
  }
}
resource "aws_vpc_security_group_ingress_rule" "dbsgin1" {
  security_group_id = aws_security_group.dbsg.id
  cidr_ipv4 = "106.51.1.25/32"
    ip_protocol = "-1"
}
resource "aws_vpc_security_group_ingress_rule" "dbsgin2" {
  security_group_id = aws_security_group.dbsg.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "icmp"
  from_port = -1
  to_port = -1
}
resource "aws_vpc_security_group_egress_rule" "dbsgout" {
    security_group_id = aws_security_group.dbsg.id
      ip_protocol = -1
    cidr_ipv4 = "0.0.0.0/0"  
}
