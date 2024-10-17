terraform {
  backend "s3" {
    bucket  = "firstbucketshadi"
    region  = "eu-west-2"
    key     = "API-Gateway-POST/terraform.tfstate"
    encrypt = true
  }
}

