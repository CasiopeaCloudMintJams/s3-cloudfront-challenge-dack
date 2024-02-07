## 1. Create S3 Bucket
##    Create Bucket Name
resource "aws_s3_bucket" "bucketlist" {
  bucket        = "colonel-sanders-bucket"
  force_destroy = true
}

## 2. Configure Bucket Ownership to "BucketOwnerEnforced"
resource "aws_s3_bucket_ownership_controls" "s3controls" {
  bucket = aws_s3_bucket.bucketlist.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

## 3. Bucket Versioning is Disabled
resource "aws_s3_bucket_versioning" "versioning"{
  bucket = aws_s3_bucket.bucketlist.id

  versioning_configuration {
    status = "Disabled"
  }
}

## 4. Attach S3-Cloudfront Policy (JSON)
##    Document to Bucket Policy
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucketlist.id
  policy = data.aws_iam_policy_document.s3_cloudfront_policy.json
}

## 5. Grab Cloudfront OAI IAM_ARN Metadata
##    And Bucket_ARN Metadata
##    To Build S3-Cloudfront Policy (JSON) Document
data "aws_iam_policy_document" "s3_cloudfront_policy" {
    statement {
        actions     = ["s3:GetObject"]
        resources   = ["${aws_s3_bucket.bucketlist.arn}/*"]
    
        principals {
            type        = "AWS"
            identifiers = [aws_cloudfront_origin_access_identity.OAI.iam_arn]
        }
    }
}

## 6. Add Objects to Bucket
##    For each loops through 
##    a variable of files / objects to upload
##    AND INCLUDING THE Folder subdirectory
resource "aws_s3_object" "html_files" {
  for_each      = fileset("${path.module}/content", "/*.html")
  bucket        = aws_s3_bucket.bucketlist.id
  key           = each.value
  source        = "${path.module}/content/${each.value}"
  content_type  = "text/html" 
}

resource "aws_s3_object" "jpg_files" {
  for_each      = fileset("${path.module}/content", "/*.jpg")
  bucket        = aws_s3_bucket.bucketlist.id
  key           = each.value
  source        = "${path.module}/content/${each.value}"
  content_type  = "image/jpg"
}