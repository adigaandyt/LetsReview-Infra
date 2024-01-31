#AWS provider
#General tags

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "andyt-s3-bucket"
    key            = "terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
  }
}

# Configure the AWS Provider
provider "aws" {
  region                   = "eu-west-1" # can't use var here?
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "andyt-develeap"

  #Tag gets added to everything
  default_tags {
    tags = {
      owner           = "andyt"
      bootcamp        = "19"
      expiration_date = "22-09-2024"
    }
  }
}
