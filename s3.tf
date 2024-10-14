resource "aws_s3_bucket_versioning" "telecom_backup" {
  bucket = "telecom-backup-bucket"
  acl    = "private"
  versioning {
    enabled = true
  }
  tags = {
    Name = "telecom-backup"
  }
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  bucket = aws_s3_bucket.telecom_backup.id

  role = aws_iam_role.replication_role.arn

  rules {
    id     = "replication_rule"
    status = "Enabled"
    destination {
      bucket        = aws_s3_bucket_telecom_backup_2.arn
      storage_class = "STANDARD"
    }
  }
}
