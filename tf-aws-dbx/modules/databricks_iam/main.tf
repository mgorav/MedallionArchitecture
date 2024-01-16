resource "aws_iam_role" "databricks_role" {
  name = "databricks-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "databricks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "s3_access_policy" {
  name        = "s3-access-policy"
  description = "Allows Databricks access to S3 buckets"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "s3:*",
        Effect   = "Allow",
        Resource = ["arn:aws:s3:::your-s3-bucket/*"]
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "databricks_policy_attachment" {
  policy_arn = aws_iam_policy.s3_access_policy.arn
  roles      = [aws_iam_role.databricks_role.name]
}

output "databricks_role_arn" {
  value = aws_iam_role.databricks_role.arn
}
