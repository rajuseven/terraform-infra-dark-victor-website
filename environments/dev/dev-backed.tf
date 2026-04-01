terraform {
  backend "s3" {
    bucket         = "raju-seven-terraform-state"
    key            = "dev/eks/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "raju-tf-lock"
    encrypt        = true
  }
}
