terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
    backend "s3" {
    bucket         = "acquisitions-terraform-prod"
    key            = "acquisitions/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks-prod"
    encrypt        = true
  }
}

provider "aws" {
    region = "us-east-1"
}

##########################
# S3 Bucket
##########################
resource "aws_s3_bucket" "acquisitions" {
  bucket = "acquisitions-terraform-prod"

  # Recommended settings
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name        = "acquisitions-terraform-prod"
    Environment = "prod"
  }
}


resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks-prod"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
  
  tags = {
    Name        = "terraform-locks-prod"
    Environment = "prod"
  }
}