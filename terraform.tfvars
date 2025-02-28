# Copyright 2025 Amazon.com and its affiliates; all rights reserved.
# This file is Amazon Web Services Content and may not be duplicated or distributed without permission.

# This sample codebase is intentionally kept lean to highlight key concepts, consequently it does not implement security best practices
# Use this codebase for learning purpose only, use security best practices before using this code in your development or production environment

APP                           = "icy"
ENV                           = "dev"
AWS_PRIMARY_REGION            = "us-east-1"
SALES_DATA_BUCKET             = "icy-dev-data"
SALES_DATA_FILE               = "s3://icy-dev-data/sales.csv"
SALES_ICEBERG_BUCKET          = "s3://icy-dev-iceberg/"
SALES_CRAWLED_ICEBERG_BUCKET  = "icy-dev-crawled-iceberg"
GLUE_SCRIPTS_BUCKET           = "s3://icy-dev-glue-scripts/"
GLUE_SPARK_LOGS_BUCKET        = "s3://icy-dev-glue-spark-logs/"
GLUE_TEMP_BUCKET              = "s3://icy-dev-glue-temp/"
ATHENA_OUTPUT_BUCKET          = "s3://icy-dev-athena-output/"

