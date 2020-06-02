resource "aws_launch_template" "myLC" {
  name_prefix   = "launch-config"
  image_id      = "ami-01c72e187b357583b"
  instance_type = "t2.micro"

  // user user data to pull docker image for ECR and run it
  user_data = ""

  // TODO fix me
  // issue with this field : terraform plan
  // * aws_autoscaling_group.my-ASG: 1 error(s) occurred:
  // * aws_autoscaling_group.my-ASG: Resource 'aws_launch_template.myLC' not found for variable 'aws_launch_template.myLC.id'

  // iam_instance_profile= ["${aws_iam_instance_profile.ec2_profile.name}"]
}

resource "aws_autoscaling_group" "my-ASG" {
  availability_zones = ["eu-west-3a"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = "${aws_launch_template.myLC.id}"
    version = "$Latest"
  }
}
