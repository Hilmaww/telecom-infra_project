# S3 Bucket resource
resource "aws_s3_bucket" "telecom_backup" {
  bucket = "telecom-backup-bucket"
  acl    = "private"

  tags = {
    Name = "telecom-backup"
  }
}

# S3 Versioning resource
resource "aws_s3_bucket_versioning" "telecom_backup_versioning" {
  bucket = aws_s3_bucket.telecom_backup.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Replication Configuration (if replication is desired to another bucket)
resource "aws_s3_bucket_replication_configuration" "replication" {
  bucket = aws_s3_bucket.telecom_backup.id

  role = aws_iam_role.replication_role.arn

  rule {
    id     = "replication_rule"
    status = "Enabled"
    destination {
      bucket        = "arn:aws:s3:::destination-bucket-name"  # Replace with actual destination bucket ARN
      storage_class = "STANDARD"
    }
  }
}

# IAM Role for S3 Replication
resource "aws_iam_role" "replication_role" {
  name = "telecom-replication-role"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "s3.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  })
}

# IAM Policy for S3 Replication
resource "aws_iam_policy" "replication_policy" {
  name = "telecom-replication-policy"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket"
        ],
        "Resource": [
          "arn:aws:s3:::telecom-backup-bucket"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "s3:GetObjectVersion",
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ],
        "Resource": [
          "arn:aws:s3:::telecom-backup-bucket/*"
        ]
      }
    ]
  })
}

# Attach IAM Policy to IAM Role for Replication
resource "aws_iam_role_policy_attachment" "replication_role_attachment" {
  role       = aws_iam_role.replication_role.name
  policy_arn = aws_iam_policy.replication_policy.arn
}
