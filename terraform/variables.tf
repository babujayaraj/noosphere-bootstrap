variable "region" {
  type    = string
  default = "us-east-1"
}

variable "aws_access_key" {
  type    = string
  default = "test"
}

variable "aws_secret_key" {
  type    = string
  default = "My-VerySecure10x-Secret"
}

variable "localstack_endpoint" {
  type        = string
  default     = "http://localhost:4566"
  description = "Override AWS endpoints for LocalStack testing"
}

variable "project" {
  type    = string
  default = "devops-tech-test"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "db_name" {
  type    = string
  default = "appdb"
}

variable "db_username" {
  type    = string
  default = "appuser"
}

variable "instances" {
  description = "Map of EC2 instance configurations"
  type = map(object({
    instance_type = string
    name          = string
  }))
  default = {}
}

variable "ami_id" {
  type        = string
  description = "Static AMI ID (LocalStack-safe)."
}