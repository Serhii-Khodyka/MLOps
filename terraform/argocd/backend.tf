terraform {
  backend "s3" {
    bucket = "serhii-my-tf-state-bucket"
    key    = "lesson7/terraform.tfstate"
    region = "us-east-1"
    profile = "default" 
  }
}
