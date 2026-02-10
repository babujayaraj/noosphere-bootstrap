variable "region" {
  type    = string
  default = "us-east-1"
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
  type = map(object({
    instance_type       = string
    subnet_index        = number
    associate_public_ip = optional(bool)
    tags                = optional(map(string))
  }))
}

variable "ami_id" {
  type        = string
  description = "Static AMI ID (LocalStack-safe)."
}