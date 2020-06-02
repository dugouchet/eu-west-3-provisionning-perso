# ALB Pub SG
resource "aws_security_group" "production-alb-pub" {
  name        = "production-pub"
  description = "Allow http inbound traffic from Internet"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "ICMP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name         = "ALB Public SG"
    "Managed By" = "Terraform"
  }
}

# Public
resource "aws_lb" "production" {
  name               = "production-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.production-alb-pub.id}"]
  subnets            = ["${aws_subnet.main-pub-a.id}", "${aws_subnet.main-pub-b.id}"]

  enable_deletion_protection = true

  #Access Logs Management 
  access_logs {
    bucket  = "${aws_s3_bucket.production_logs.bucket}"
    prefix  = "production-pub-alb"
    enabled = true
  }

  tags {
    name         = "Production Public ALB"
    "Managed By" = "Terraform"
  }
}

resource "aws_alb_target_group" "alb_pub_production_http" {
  name     = "albpubproduction"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.main.id}"
}
