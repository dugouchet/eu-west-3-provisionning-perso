resource "aws_ecr_repository" "my-ecr" {
  name                 = "my-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags {
    Name         = "my-ecr"
    "Managed By" = "Terraform"
  }
}
