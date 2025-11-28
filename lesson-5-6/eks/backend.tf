terraform {
  backend "s3" {
    bucket = "serhii-my-tf-state-bucket"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}
