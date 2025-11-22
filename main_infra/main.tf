terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>6.0"   
    }
  }
}
terraform {
  backend "s3" {
    encrypt = true
  }
}

provider "aws" {
  region = "us-east-1"  
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

variable "instance_type" {
  type    = string
  description = "EC2 instance type"
}
resource "aws_instance" "first_instnace" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type 


tags = {
  Name = "terraform_instance"  
}
}
