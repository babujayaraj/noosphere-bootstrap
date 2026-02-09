resource "aws_s3_bucket" "artifacts" {
  bucket = "${var.project}-${var.environment}-artifacts"

  # Useful for dev/localstack so destroy doesn't fail
  force_destroy = true

  tags = {
    Name        = "${var.project}-${var.environment}-artifacts"
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "artifacts_lifecycle" {
  bucket = aws_s3_bucket.artifacts.id

  rule {
    id     = "expire-objects-after-7-days"
    status = "Enabled"

    expiration {
      days = 7
    }
  }
}