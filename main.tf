provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_vpc" "default" {
  cidr_block	= "${var.default_vpc_cidr}"
  
  tags = {
    Name = "Default VPC"
    env = "PROD"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"

  tags = {
    Name = "Default GW"
    env = "PROD"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

resource "aws_subnet" "default" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "${var.default_subnet_cidr}"
  map_public_ip_on_launch = true


  tags = {
    Name = "Default Subnet"
    env = "PROD"
  }
}

resource "aws_security_group" "basic" {
  name        = "basic"
  description = "Basic Security Group"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port	= 8
    to_port	= 0
    protocol	= "icmp"
    cidr_blocks	= ["0.0.0.0/0"]
  }

  ingress {
    from_port	= 22
    to_port	= 22
    protocol	= "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
    

  tags = {
    Name	= "basic"
    env		= "PROD"
  }
}

resource "aws_key_pair" "jlowry" {
  key_name   = "John Lowry"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCc9cC2xs+EU8awpCf6eAY7S9IGqL6/r1LpV3r5Lo1NCE9gTPofk+ACMKhxnLRxUdqGs0aMA9k1HngJ5oE5PKp9DkE9ZIjryG7UhPfrvsTnU0Ak+Ltx0cXy/1NoWmMDSckCBdeqONRaxdi9kz6H3DCMeQD8Xu5KafWTlbLgdJveEaEDbWlKF0smpvKieeCW+iBjcqA2ZusDvaBKHQRa4CpcSWiI+fsoJXYItZXZFmNYmDiNL9P1bzwa7MSnHN7gRU2yJy6J3Mil69p3bKI347pxbBVUMBT2bSbj/OP6nr6yP85JF8jlJl7XekabqtRNnDW6rOGApufh/4etCh2yBOQ9"
}

resource "aws_key_pair" "debian-box" {
  key_name   = "DebianBox"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCzc3jwiqJOl5QYb0JRnTav17hitSUODL/D5WWODnCBPbxx8W/jYltFKQe/tK08Ls3sUAfGbmYp/MNHlgHEdcJ2MqgmVZEGbByoQpapQVWzQ6zLeTeFPv4e7qVxT4OK8+V/Fi+ezewfBBU5BqqEA6ZRgCZ/ILM0dlyvYQEwOVgP+TZz8UFMqsz24fkoEG8fYVjoibmrqc0Lb9rhpgF30WrSqZVfq7e9/ehmR2ZaQQeSpMw819bkWDAKYXS2Bo1pamd5LD360NfGojDM5QRT8tROwqjtgWMAwQ1qzLl30iFhjRnS2bn8BgmAp0iCLkyMcJJGOyF51FWeedY+2WmBHNhKkGe6igui3ycmkenhh30U+L7R9jd28E7BpjM17bFVOKtYEv4b2MpqSYcNT9k6U6y43bZEc187gc6VMWx0FQuVusgHQX+WK+yUacC0QaJs6YAStI9WVLLdpTviHI91dYw9ewBZ05xqG2VjnWEr1ifrE8nytYroBPeUzlqJ4Itq0LJdDVjCDSqwJ8BFNSJ/SGUF71rUkLciCh9SdG9JxxOeBJcKcnDTe8ycmdXNHSIyCmQbdb0MXsPfQwjXCVYrFi5Xg+pZpFotWcMBE3x7S3wKDs65/hL6y1+9d4ueucHQWtyOMniQOQu+1F0mSGaHEOkh8drNjeDA+tjjJyFxDjHlqQ=="
}

resource "aws_instance" "dev" {
  instance_type			= "t2.micro"
  ami				= "ami-7f43f307"
  key_name			= "${aws_key_pair.debian-box.id}"
  vpc_security_group_ids	= ["${aws_security_group.basic.id}"]
  subnet_id			= "${aws_subnet.default.id}"


  tags	= {
    Name	= "bastion"
    env		= "PROD"
  }
}
