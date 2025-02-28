// Copyright 2025 Amazon.com and its affiliates; all rights reserved.
// This file is Amazon Web Services Content and may not be duplicated or distributed without permission.

// This sample codebase is intentionally kept lean to highlight key concepts, consequently it does not implement security best practices
// Use this codebase for learning purpose only, use security best practices before using this code in your development or production environment

// glue role
resource "aws_iam_role" "aws_iam_glue_role" {

  name = "${var.APP}-${var.ENV}-glue-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "glue.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "glue_service_attachment" {

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
  role = aws_iam_role.aws_iam_glue_role.id
}

resource "aws_iam_role_policy" "glue_policy" {

  name = "${var.APP}-${var.ENV}-glue-policy"
  role = aws_iam_role.aws_iam_glue_role.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        Effect = "Allow"
        Action = [
          "s3:ListAllMyBuckets",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::${var.APP}-${var.ENV}-data/*",
          "arn:aws:s3:::${var.APP}-${var.ENV}-iceberg/*",
          "arn:aws:s3:::${var.APP}-${var.ENV}-glue-scripts/*",
          "arn:aws:s3:::${var.APP}-${var.ENV}-glue-jars/*",
          "arn:aws:s3:::${var.APP}-${var.ENV}-glue-spark-logs*",
          "arn:aws:s3:::${var.APP}-${var.ENV}-glue-temp/*",
          "arn:aws:s3:::${var.APP}-${var.ENV}-athena-output/*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
            "logs:AssociateKmsKey",
        ],
        "Resource": "arn:aws:logs:${var.AWS_PRIMARY_REGION}:${local.account_id}:*"
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey"
        ]
        Resource = ["arn:aws:kms:${var.AWS_PRIMARY_REGION}:${local.account_id}:*"]
      },
      {
        Effect = "Allow"
        Action = [
          "s3tables:*"
        ]
        Resource = ["*"]
      },
      {
        Effect = "Allow"
        Action = [
          "lakeformation:GetDataAccess"
        ]
        Resource = ["*"]
      }
    ]
  })
}
