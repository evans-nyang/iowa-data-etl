terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">=1.2.0"
}

provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "iowa_data" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

resource "aws_s3_bucket_ownership_controls" "iowa_data" {
  bucket = aws_s3_bucket.iowa_data.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "iowa_data" {
  depends_on = [aws_s3_bucket_ownership_controls.iowa_data]

  bucket = aws_s3_bucket.iowa_data.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning_iowa_data" {
  bucket = aws_s3_bucket.iowa_data.id
  versioning_configuration {
    status = "Enabled"
  }
}
