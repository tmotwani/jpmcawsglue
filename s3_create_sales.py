
# Copyright 2025 Amazon.com and its affiliates; all rights reserved.
# This file is Amazon Web Services Content and may not be duplicated or distributed without permission.

# This sample codebase is intentionally kept lean to highlight key concepts, consequently it does not implement security best practices
# Use this codebase for learning purpose only, use security best practices before using this code in your development or production environment

import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.conf import SparkConf  

args = getResolvedOptions(sys.argv, ['JOB_NAME', 'TABLE_BUCKET_ARN'])
TABLE_BUCKET_ARN = args.get("TABLE_BUCKET_ARN")

# Spark configuration for S3 Tables
conf = SparkConf()
conf.set("spark.sql.catalog.s3tablescatalog", "org.apache.iceberg.spark.SparkCatalog")
conf.set("spark.sql.catalog.s3tablescatalog.catalog-impl", "software.amazon.s3tables.iceberg.S3TablesCatalog")
conf.set("spark.sql.catalog.s3tablescatalog.warehouse", TABLE_BUCKET_ARN)
conf.set("spark.sql.extensions", "org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions")

sparkContext = SparkContext(conf=conf)

glueContext = GlueContext(sparkContext)

spark = glueContext.spark_session

spark.sql("CREATE NAMESPACE IF NOT EXISTS s3tablescatalog.icy")           

spark.sql("CREATE TABLE s3tablescatalog.icy.sales (date string, store_id string, product_id string, sales_amount string, units_sold string) USING iceberg")

