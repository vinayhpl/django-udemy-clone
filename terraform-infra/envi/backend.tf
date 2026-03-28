terraform {
  backend "s3" {
    bucket         = "tummoc-terraform-bucket"
    key            = "envi/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock"
  }
}