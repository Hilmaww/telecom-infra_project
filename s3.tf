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
