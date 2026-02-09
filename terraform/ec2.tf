# EC2 Instances
# LocalStack does not provide real AMI catalog lookups (DescribeImages),
resource "aws_instance" "ec2" {
  for_each = var.instances

  ami           = var.ami_id
  instance_type = each.value.instance_type

  # Select one of the created public subnets by index
  subnet_id = local.public_subnet_ids[each.value.subnet_index]

  # Optional: helpful toggles per instance
  associate_public_ip_address = try(each.value.associate_public_ip, true)

  tags = merge(
    {
      Name        = each.key
      Project     = var.project
      Environment = var.environment
      ManagedBy   = "terraform"
    },
    try(each.value.tags, {})
  )
}



