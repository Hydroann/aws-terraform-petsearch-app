#Pet Images Bucket 
resource "aws_s3_bucket" "pet_images" {
  # Account ID makes this unique globally
  bucket = "petsearch-pet-images-${var.current_account_id}"

  tags = {
    Name    = "petsearch-pet-images"
    Purpose = "Pet photos for lost and found listings"
  }
}

resource "aws_s3_bucket_public_access_block" "pet_images" {
  bucket = aws_s3_bucket.pet_images.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "pet_images" {
  bucket = aws_s3_bucket.pet_images.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_cors_configuration" "pet_images" {
  bucket = aws_s3_bucket.pet_images.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST"]
    allowed_origins = ["*"]
    max_age_seconds = 3600
  }
}



# Documents Bucket 
resource "aws_s3_bucket" "documents" {
  bucket = "petsearch-documents-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name    = "petsearch-documents"
    Purpose = "Adoption papers, vet records, and other uploaded documents"
  }
}

resource "aws_s3_bucket_public_access_block" "documents" {
  bucket = aws_s3_bucket.documents.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "documents" {
  bucket = aws_s3_bucket.documents.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_cors_configuration" "documents" {
  bucket = aws_s3_bucket.documents.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST"]
    allowed_origins = ["*"]
    max_age_seconds = 3600
  }
}