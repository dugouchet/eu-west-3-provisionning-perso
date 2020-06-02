terraform {
  backend "s3" {
    bucket = "my-tf-state-dugouchet"
    key    = "production"
    region = "eu-west-3"
    acl    = "bucket-owner-full-control"
  }
}
