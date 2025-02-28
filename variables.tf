# Copyright 2025 Amazon.com and its affiliates; all rights reserved.
# This file is Amazon Web Services Content and may not be duplicated or distributed without permission.

# This sample codebase is intentionally kept lean to highlight key concepts, consequently it does not implement security best practices
# Use this codebase for learning purpose only, use security best practices before using this code in your development or production environment

variable "APP" {

  type = string
}

variable "ENV" {

  type = string
}

variable "AWS_PRIMARY_REGION" {

  type = string
}

variable "SALES_DATA_BUCKET" {

  type = string
}

variable "SALES_DATA_FILE" {

  type = string
}

variable "SALES_ICEBERG_BUCKET" {

  type = string
}

variable "SALES_CRAWLED_ICEBERG_BUCKET" {

  type = string
}

variable "GLUE_SCRIPTS_BUCKET" {

  type = string
}

variable "GLUE_SPARK_LOGS_BUCKET" {

  type = string
}

variable "GLUE_TEMP_BUCKET" {

  type = string
}

variable "ATHENA_OUTPUT_BUCKET" {

  type = string
}