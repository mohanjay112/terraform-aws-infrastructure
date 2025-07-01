terraform {
  backend "s3" {
    bucket = "terraform-0077 "
    key    = "terraform/backend"
    region = "us-east-2"
  }
}