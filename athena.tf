// Copyright 2025 Amazon.com and its affiliates; all rights reserved.
// This file is Amazon Web Services Content and may not be duplicated or distributed without permission.

// This sample codebase is intentionally kept lean to highlight key concepts, consequently it does not implement security best practices
// Use this codebase for learning purpose only, use security best practices before using this code in your development or production environment

resource "aws_athena_workgroup" "athena_workgroup" {

  name = "icy-workgroup"

  configuration {

    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = true

    result_configuration {

      output_location = var.ATHENA_OUTPUT_BUCKET
    }
  }
}