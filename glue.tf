// Copyright 2025 Amazon.com and its affiliates; all rights reserved.
// This file is Amazon Web Services Content and may not be duplicated or distributed without permission.

// This sample codebase is intentionally kept lean to highlight key concepts, consequently it does not implement security best practices
// Use this codebase for learning purpose only, use security best practices before using this code in your development or production environment

resource "aws_glue_catalog_database" "glue_database" {

  name = "${var.APP}_${var.ENV}_sales"
}

resource "aws_glue_catalog_table" "sales_data" {

  name          = "${var.APP}_${var.ENV}_sales_data"
  database_name = aws_glue_catalog_database.glue_database.name

  table_type = "EXTERNAL_TABLE"

  parameters = {

    "classification"          = "csv"
    "areColumnsQuoted"        = "false"
    "delimiter"               = ","
    "skip.header.line.count"  = "1"  
    "typeOfData"              = "file"
    "EXTERNAL"                = "TRUE"
  }

  storage_descriptor {

    location      = var.SALES_DATA_FILE
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      name                  = "csv-serde"
      serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"

      parameters = {
        "separatorChar"   = ","
        "quoteChar"      = "\""
        "escapeChar"     = "\\"
      }
    }

    columns {
      name = "date"
      type = "string"
    }

    columns {
      name = "store_id"
      type = "string"
    }

    columns {
      name = "product_id"
      type = "string"
    }

    columns {
      name = "sales_amount"
      type = "string"
    }

    columns {
      name = "units_sold"
      type = "string"
    }
  }
}

resource "aws_glue_catalog_table" "sales_iceberg" {

  name          = "${var.APP}_${var.ENV}_sales_iceberg"
  database_name = aws_glue_catalog_database.glue_database.name

  table_type = "EXTERNAL_TABLE"

  open_table_format_input {
    iceberg_input {
      metadata_operation = "CREATE"
    }
  }

  storage_descriptor {

    location      = var.SALES_ICEBERG_BUCKET

    columns {
      name = "date"
      type = "string"
    }

    columns {
      name = "store_id"
      type = "string"
    }

    columns {
      name = "product_id"
      type = "string"
    }

    columns {
      name = "sales_amount"
      type = "string"
    }

    columns {
      name = "units_sold"
      type = "string"
    }
  }
}

resource "aws_glue_classifier" "sales_classifier" {

  name = "${var.APP}-${var.ENV}-sales-classifier"

  csv_classifier {
    header = ["date", "store_id", "product_id", "sales_amount", "units_sold"]
    custom_datatype_configured = true
    custom_datatypes = ["STRING", "STRING", "STRING", "STRING", "STRING"]
    contains_header = "PRESENT"
    quote_symbol = "\""
    delimiter = ","
    allow_single_column = false
    disable_value_trimming = false
  }
}

resource "aws_glue_crawler" "sales_crawler" {

  name = "${var.APP}-${var.ENV}-sales-crawler"

  database_name = aws_glue_catalog_database.glue_database.name
  classifiers = [aws_glue_classifier.sales_classifier.id]
  role = aws_iam_role.aws_iam_glue_role.arn

  iceberg_target {
    paths = ["icy-dev-iceberg"]
    maximum_traversal_depth = 3
  }

  schema_change_policy {
    delete_behavior = "LOG"
    update_behavior = "UPDATE_IN_DATABASE"
  }

  configuration = jsonencode({
    Version = 1.0
    Grouping = {
      TableGroupingPolicy = "CombineCompatibleSchemas"
    }
  })
  
  depends_on = [
    aws_glue_catalog_database.glue_database,
    aws_glue_classifier.sales_classifier
  ]
}

resource "aws_glue_job" "sales_job" {

  name              = "${var.APP}-${var.ENV}-sales"
  description       = "${var.APP}-${var.ENV}-sales"
  role_arn          = aws_iam_role.aws_iam_glue_role.arn
  glue_version      = "5.0"
  worker_type       = "G.1X"
  number_of_workers = 10

  command {
    script_location = "s3://${var.APP}-${var.ENV}-glue-scripts/sales.py"
  }
 
  default_arguments = {
    "--SOURCE_DATABASE_NAME"              = aws_glue_catalog_database.glue_database.name
    "--SOURCE_TABLE_NAME"                 = aws_glue_catalog_table.sales_data.name
    "--TARGET_DATABASE_NAME"              = aws_glue_catalog_database.glue_database.name
    "--TARGET_TABLE_NAME"                 = aws_glue_catalog_table.sales_iceberg.name
    "--TempDir"                           = var.GLUE_TEMP_BUCKET
    "--enable-continuous-cloudwatch-log"  = "true"
    "--enable-job-insights"               = "true"   
    "--enable-metrics"                    = "true"
    "--enable-observability-metrics"      = "true"
    "--enable-spark-ui"                   = "true"
    "--spark-event-logs-path"             = var.GLUE_SPARK_LOGS_BUCKET
    "--enable-glue-datacatalog"           = "true" 
    "--datalake-formats"                  = "iceberg"
    "--conf"                              = "spark.sql.defaultCatalog=glue_catalog --conf spark.sql.catalog.glue_catalog.warehouse=${var.SALES_ICEBERG_BUCKET} --conf spark.sql.catalog.glue_catalog=org.apache.iceberg.spark.SparkCatalog --conf spark.sql.catalog.glue_catalog.catalog-impl=org.apache.iceberg.aws.glue.GlueCatalog --conf spark.sql.catalog.glue_catalog.io-impl=org.apache.iceberg.aws.s3.S3FileIO --conf spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions"
  }
}

resource "aws_glue_job" "sales_s3_create_job" {

  name              = "${var.APP}-${var.ENV}-sales-s3-create"
  description       = "${var.APP}-${var.ENV}-sales-s3-create"
  role_arn          = aws_iam_role.aws_iam_glue_role.arn
  glue_version      = "5.0"
  worker_type       = "G.1X"
  number_of_workers = 10

  command {
    script_location = "s3://${var.APP}-${var.ENV}-glue-scripts/s3_create_sales.py"
  }
 
  default_arguments = {
    "--extra-jars" = "s3://${var.APP}-${var.ENV}-glue-jars/s3-tables-catalog-for-iceberg-runtime-0.1.5.jar"
    "--TABLE_BUCKET_ARN"    = "arn:aws:s3tables:${local.region}:${local.account_id}:bucket/${var.APP}-${var.ENV}-sales"
    "--datalake-formats" = "iceberg"
    "--user-jars-first" = "true"
  }
}

resource "aws_glue_job" "sales_s3_delete_job" {

  name              = "${var.APP}-${var.ENV}-sales-s3-delete"
  description       = "${var.APP}-${var.ENV}-sales-s3-delete"
  role_arn          = aws_iam_role.aws_iam_glue_role.arn
  glue_version      = "5.0"
  worker_type       = "G.1X"
  number_of_workers = 10

  command {
    script_location = "s3://${var.APP}-${var.ENV}-glue-scripts/s3_delete_sales.py"
  }
 
  default_arguments = {
    "--extra-jars"          = "s3://${var.APP}-${var.ENV}-glue-jars/s3-tables-catalog-for-iceberg-runtime-0.1.5.jar"
    "--TABLE_BUCKET_ARN"    = "arn:aws:s3tables:${local.region}:${local.account_id}:bucket/${var.APP}-${var.ENV}-sales"
    "--datalake-formats"    = "iceberg"
    "--user-jars-first"     = "true"
  }
}

resource "aws_glue_job" "s3_sales_job" {

  name              = "${var.APP}-${var.ENV}-s3-sales"
  description       = "${var.APP}-${var.ENV}-s3-sales"
  role_arn          = aws_iam_role.aws_iam_glue_role.arn
  glue_version      = "5.0"
  worker_type       = "G.1X"
  number_of_workers = 10

  command {
    script_location = "s3://${var.APP}-${var.ENV}-glue-scripts/s3_sales.py"
  }
 
  default_arguments = {
    "--SOURCE_DATABASE_NAME"    = aws_glue_catalog_database.glue_database.name
    "--SOURCE_TABLE_NAME"       = aws_glue_catalog_table.sales_data.name
    "--TABLE_BUCKET_ARN"        = "arn:aws:s3tables:${local.region}:${local.account_id}:bucket/${var.APP}-${var.ENV}-sales"
    "--extra-jars"              = "s3://${var.APP}-${var.ENV}-glue-jars/s3-tables-catalog-for-iceberg-runtime-0.1.5.jar"
    "--datalake-formats"        = "iceberg"
    "--user-jars-first"         = "true"
  }
}