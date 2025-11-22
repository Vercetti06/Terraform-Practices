terraform{
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~>6.0"
    }
  } 
}

provider "aws" {
  region = "us-east-1"      
}

data "aws_caller_identity" "current"{}

locals{
    account_id = data.aws_caller_identity.current.account_id
}

resource "aws_s3_bucket" "terra_state_bucket"{
  bucket = "${local.account_id}-terra-state" 

}
resource "aws_s3_bucket_server_side_encryption_configuration" "terra_encrypt"  {
  bucket = aws_s3_bucket.terra_state_bucket.bucket
  rule{
    apply_server_side_encryption_by_default{
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "terra_state_versioning"{
  bucket = aws_s3_bucket.terra_state_bucket.bucket
  versioning_configuration {
    status = "Enabled"
}
}

resource "aws_dynamodb_table" "dynamo-db-table" {
  name = "dynamic_table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute  {
    name = "LockID"
    type = "S"
  }
}
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {  
  name = "name"
  values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]  
}

filter {
  name = "virtualization-type"
  values = ["hvm"]  
}
owners = ["099720109477"] # Canonical
}

resource "aws_instance" "first_instnace" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t3.micro" 


tags = {
  Name = "terraform_instance"  
}
}



