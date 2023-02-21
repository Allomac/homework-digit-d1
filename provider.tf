terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
provider "aws" {
  region  = var.region
  profile = "terraform-user" # here you can replace terraform-user with your profile name
  #shared_credentials_file = "/d/Users/allamar/.aws/credentials" 
}