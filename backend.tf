terraform {
  backend "s3" {
    bucket         = "askheystupid-terraform-state-jmbtdn8x"
    key            = "askheystupid/terraform.tfstate"
    region         = "us-east-2" # Change this if you used a different region
    dynamodb_table = "askheystupid-terraform-locks"
    encrypt        = true
  }
}

