// Copyright 2025 Amazon.com and its affiliates; all rights reserved.
// This file is Amazon Web Services Content and may not be duplicated or distributed without permission.

// This sample codebase is intentionally kept lean to highlight key concepts, consequently it does not implement security best practices
// Use this codebase for learning purpose only, use security best practices before using this code in your development or production environment

resource "aws_s3tables_table_bucket" "sales" {
  
  name = "${var.APP}-${var.ENV}-sales"
}

data "aws_iam_policy_document" "sales_bucket_policy_document" {
  
  statement {
    sid = "AllowAthenaAccess"
    effect = "Allow"
    
    principals {
      type        = "Service"
      identifiers = ["athena.amazonaws.com"]
    }
    
    actions = [
      "s3tables:*"
    ]
    
    resources = [
      "${aws_s3tables_table_bucket.sales.arn}/*",
      aws_s3tables_table_bucket.sales.arn
    ]
  }

  statement {
    sid = "AllowGlueAccess"
    effect = "Allow"
    
    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
    
    actions = [
      "s3tables:*"
    ]
    
    resources = [
      "${aws_s3tables_table_bucket.sales.arn}/*",
      aws_s3tables_table_bucket.sales.arn
    ]
  }
}

resource "aws_s3tables_table_bucket_policy" "sales_policy" {

  resource_policy  = data.aws_iam_policy_document.sales_bucket_policy_document.json
  table_bucket_arn = aws_s3tables_table_bucket.sales.arn
}
