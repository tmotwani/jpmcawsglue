// Copyright 2025 Amazon.com and its affiliates; all rights reserved.
// This file is Amazon Web Services Content and may not be duplicated or distributed without permission.

// This sample codebase is intentionally kept lean to highlight key concepts, consequently it does not implement security best practices
// Use this codebase for learning purpose only, use security best practices before using this code in your development or production environment

resource "aws_s3_bucket" "data_bucket" {

  bucket = "${var.APP}-${var.ENV}-data"
}

resource "aws_s3_bucket" "iceberg_bucket" {

  bucket = "${var.APP}-${var.ENV}-iceberg"
}

resource "aws_s3_bucket" "crawled_iceberg_bucket" {

  bucket = "${var.APP}-${var.ENV}-crawled-iceberg"
}

resource "aws_s3_bucket" "glue_scripts_bucket" {

  bucket = "${var.APP}-${var.ENV}-glue-scripts"
}

resource "aws_s3_bucket" "glue_jars_bucket" {

  bucket = "${var.APP}-${var.ENV}-glue-jars"
}

resource "aws_s3_bucket" "glue_spark_logs_bucket" {

  bucket = "${var.APP}-${var.ENV}-glue-spark-logs"
}

resource "aws_s3_bucket" "glue_temp_bucket" {

  bucket = "${var.APP}-${var.ENV}-glue-temp"
}

resource "aws_s3_bucket" "athena_output_bucket" {

  bucket = "${var.APP}-${var.ENV}-athena-output"
}