
terraform {
  backend "s3" {
    bucket         = "terraform-remote-614270925438-us-east-1-an"
    key            = "dev/eks/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "raju-tf-lock"
    encrypt        = true
  }
}
