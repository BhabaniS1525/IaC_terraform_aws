terraform {
  backend "s3" {
    bucket = "terraform-state-1525"
    key    = "terraform/backend"
    region = "us-east-1"
  }
}
