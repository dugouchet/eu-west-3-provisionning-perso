locals {
  my-user-data = <<USERDATA
#!/bin/bash
yum update
yum install -y httpd.x86_64
systemctl start httpd.service
systemctl enable httpd.service
echo "hello devops!" > /var/www/html/index.html
USERDATA
}

resource "aws_security_group" "allow_http_from_alb" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "TCP"
    security_groups = ["${aws_security_group.production-alb-pub.id}"] # Allow communication from ALB health check
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http"
  }
}

resource "aws_launch_template" "myLC" {
  name_prefix   = "launch-config"
  image_id      = "ami-01c72e187b357583b"
  instance_type = "t2.micro"

  vpc_security_group_ids = ["${aws_security_group.allow_http_from_alb.id}"]

  user_data = "${base64encode(local.my-user-data)}"

  iam_instance_profile {
    name = "${aws_iam_instance_profile.ec2_profile.name}"
  }
}

resource "aws_autoscaling_group" "my-ASG" {
  availability_zones = ["eu-west-3a"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1
  
  vpc_zone_identifier       = ["${aws_subnet.main-pub-a.id}", "${aws_subnet.main-pub-b.id}"]
  
  launch_template {
    id      = "${aws_launch_template.myLC.id}"
    version = "$Latest"
  }

  target_group_arns = ["${aws_alb_target_group.alb_pub_production_http.arn}"]
}
