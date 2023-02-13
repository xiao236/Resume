terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.15.0"
    }
  }
  backend "s3" {
    bucket = "state-file-resume"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
