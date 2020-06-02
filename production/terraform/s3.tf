resource "aws_s3_bucket" "production_logs" {
  bucket = "productionlogs"
  acl    = "private"

  tags = {
    "Managed by"  = "Terraform"
    "Application" = "bucket for prod logs"
  }
}