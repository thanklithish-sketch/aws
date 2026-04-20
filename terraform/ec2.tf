
# web server deployment(web1)
resource "aws_instance" "webins" {
  ami                         = "ami-02dfbd4ff395f2a1b"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_01.id
  associate_public_ip_address = true
  availability_zone           = "us-east-1a"
  key_name                    = "secondary account"
  vpc_security_group_ids = [aws_security_group.websg.id] //security groups must be defined within []
  tags = {
    Name = "web-server1"
  }
}
# by default vpc creates a eni and then default ebs
# creation of additional volume
resource "aws_ebs_volume" "webvol" {
  availability_zone = "us-east-1a"
  size              = 40
  tags = {
    Name = "sec_disk_web"
  }
}
#attachment of additional volume
resource "aws_volume_attachment" "web_attch" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.webvol.id
  instance_id = aws_instance.webins.id
}



### app server
resource "aws_instance" "appins" {
  ami               = "ami-02dfbd4ff395f2a1b"
  instance_type     = "t3.micro"
  availability_zone = "us-east-1a"
  subnet_id         = aws_subnet.private_01.id
  key_name          = "secondary account"
  vpc_security_group_ids = [aws_security_group.appsg.id]
  tags = {
    Name = "app-server"
  }
}
#app server additional disk
resource "aws_ebs_volume" "appvol" {
  availability_zone = "us-east-1a"
  size              = 30
  tags = {
    Name = "sec_disk_app"
  }
}
#app server disk attachment
resource "aws_volume_attachment" "app_attach" {
  device_name = "/dev/sdk"
  instance_id = aws_instance.appins.id
  volume_id   = aws_ebs_volume.appvol.id
}



# DB server

resource "aws_instance" "dbins" {
  ami               = "ami-02dfbd4ff395f2a1b"
  subnet_id         = aws_subnet.private_02.id
  instance_type     = "t3.micro"
  availability_zone = "us-east-1a"
  key_name          = "secondary account"
  vpc_security_group_ids = [aws_security_group.dbsg.id]
  tags = {
    Name = "db-server"
  }
}
#db server additional disk
resource "aws_ebs_volume" "dbvol" {
  availability_zone = "us-east-1a"
  size              = 30
  tags = {
    Name = "sec_disk_db"
  }
}
# db server disk attachment
resource "aws_volume_attachment" "db_attach" {
  device_name = "/dev/sde"
  volume_id   = aws_ebs_volume.dbvol.id
  instance_id = aws_instance.dbins.id
}


