# Backend config to store tfstate in an S3 bucket

terraform {
  backend "s3" {
    bucket = "sctp-ce9-tfstate"
    key    = "luke-ce9-activity3-1.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}