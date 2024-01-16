terraform {

  cloud {
    organization = "tiger_projects"
    workspaces {
      name = "backup-s3-solution"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "backup_bucket" {
  bucket = "my-backup-bucket"
}

resource "aws_s3_bucket_ownership_controls" "backup_bucket_ownership_controls" {
  bucket = aws_s3_bucket.backup_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred" # This means that if someone else uploads a file to your bucket, you, as the bucket owner, will become the owner of that file.
  }
}

resource "aws_s3_bucket_acl" "backup_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.backup_bucket_ownership_controls]

  bucket = aws_s3_bucket.backup_bucket.id
  acl    = "private" # private since this is sensitive data considered as backup
}