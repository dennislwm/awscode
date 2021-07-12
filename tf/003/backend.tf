provider "aws" {
  region = "us-east-2"
}

terraform {
  required_version = ">=0.12.0"
  backend "s3" {
    region = "us-east-2"
    key    = "terraform-003.tfstate"
    bucket = "awscode-tf-bucket"
  }
}
