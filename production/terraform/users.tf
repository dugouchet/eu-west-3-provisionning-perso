# user for github action to push images to ECR
resource "aws_iam_user" "user-ci" {
  name = "user-ci"

  tags = {
    "Managed by"  = "Terraform"
    "Application" = "github-ci"
  }
}

resource "aws_iam_policy" "policy_application-ci" {
  name = "trf-policy_application-ci"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:*",
                "cloudtrail:LookupEvents"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}

resource "aws_iam_policy_attachment" "policy-attachment_application-ci" {
  name       = "trf-policy-attachment_application-ci"
  users      = ["user-ci"]
  policy_arn = "${aws_iam_policy.policy_application-ci.arn}"
}

# ec2 user to pull image from ECR

resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    "Managed by"  = "Terraform"
    "Application" = "ec2"
  }
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = "${aws_iam_role.ec2_role.name}"
}

resource "aws_iam_role_policy" "ec2_policy" {
  name = "ec2_policy"
  role = "${aws_iam_role.ec2_role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
