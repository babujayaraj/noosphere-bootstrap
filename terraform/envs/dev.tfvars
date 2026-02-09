# Environment / project 
environment = "dev"
project     = "devops-tech-test"

# Static AMI ID (placeholder for LocalStack)
ami_id = "ami-12345678"

# EC2 3 diff instances (repeatable & extendable)

instances = {
  web = {
    instance_type = "t3.micro"
    subnet_index  = 0
    tags          = { Role = "web" }
  }

  api = {
    instance_type = "t3.small"
    subnet_index  = 1
    tags          = { Role = "api" }
  }

  worker = {
    instance_type       = "t3.medium"
    subnet_index        = 0
    associate_public_ip = true
    tags                = { Role = "worker" }
  }
}