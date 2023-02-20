terraform {
  backend "s3" {
   
    bucket         = "my-terraform-state-bucket-d1"
    key            = "global/s3/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "dynamodb-state-locking"
    encrypt        = true
    profile = "terraform-user"
  }
}