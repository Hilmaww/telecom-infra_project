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

  rule {
	id     = "replication_rule"
	status = "Enabled"
	destination {
	  bucket        = aws_s3_bucket_telecom_backup_2.arn
	  storage_class = "STANDARD"
	}
  }
}

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

resource "aws_iam_role_policy_attachment" "replication_role_attachment" {
  role       = aws_iam_role.replication_role.name
  policy_arn = aws_iam_policy.replication_policy.arn
}
