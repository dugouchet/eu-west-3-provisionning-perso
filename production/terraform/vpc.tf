resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "IG" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name         = "Internet Gateway"
    "Managed By" = "Terraform"
  }
}

resource "aws_subnet" "main-pub-a" {
  availability_zone = "eu-west-3a"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "10.0.0.0/24"

  map_public_ip_on_launch = "true"

  tags = {
    Name = "Main pub subnet"
  }
}

resource "aws_subnet" "main-pub-b" {
  availability_zone = "eu-west-3b"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "10.0.1.0/24"

  map_public_ip_on_launch = "true"

  tags = {
    Name = "Main pub subnet"
  }
}

resource "aws_route_table" "productionpub" {
  vpc_id = "${aws_vpc.main.id}"

  # Default
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.IG.id}"
  }

  tags {
    "Name"       = "Public Route Table"
    "Managed By" = "Terraform"
  }
}

resource "aws_route_table_association" "route_table_association-subnet-A" {
  subnet_id      = "${aws_subnet.main-pub-a.id}"
  route_table_id = "${aws_route_table.productionpub.id}"
}

resource "aws_route_table_association" "route_table_association-subnet-B" {
  subnet_id      = "${aws_subnet.main-pub-b.id}"
  route_table_id = "${aws_route_table.productionpub.id}"
}
