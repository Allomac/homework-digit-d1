
# Creation of webserver with wordpress
resource "aws_instance" "myserver" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public-1a.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.http-sg.id]
  key_name                    = var.keyname
  user_data                   = file("userdata.sh")

  user_data_replace_on_change = true

  tags = {
    Name = "tf-webserver"
  }
}

# Creation of security group for webserver

resource "aws_security_group" "http-sg" {
  name        = "allow_http_access"
  description = "allow inbound http traffic"
  vpc_id      = aws_vpc.my-vpc.id

  ingress {
    description = "from my ip range"
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    to_port     = "0"
  }
  tags = {
    "Name" = "Application-sg"
  }
  lifecycle {
    create_before_destroy = true
  }
}

# Creation of mysql database in private subnet

resource "aws_instance" "mysql-db" {
  ami                    = "ami-0a896b04a8a52170e"
  instance_type          = var.instance_type
  key_name               = var.keyname
  subnet_id              = aws_subnet.private-1a.id
  vpc_security_group_ids = [aws_security_group.mysql-sg.id]
  tags = {
    Name = "mysql-os"
  }
}

# Creation of security group for database 

resource "aws_security_group" "mysql-sg" {
  name        = "basic"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.my-vpc.id


  ingress {
    description = "mysql"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "mysql-sg"
  }
}
