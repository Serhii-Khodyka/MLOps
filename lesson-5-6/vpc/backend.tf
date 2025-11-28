terraform {
  backend "s3" {
    bucket = "serhii-my-tf-state-bucket"
    key    = "vpc/terraform.tfstate"
    region = "us-east-1"
  }
}
