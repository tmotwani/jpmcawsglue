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

args = getResolvedOptions(sys.argv, ['JOB_NAME', 'SOURCE_DATABASE_NAME', 'SOURCE_TABLE_NAME', 'TARGET_DATABASE_NAME', 'TARGET_TABLE_NAME'])

SOURCE_DATABASE_NAME = args.get("SOURCE_DATABASE_NAME")
SOURCE_TABLE_NAME = args.get("SOURCE_TABLE_NAME")
TARGET_DATABASE_NAME = args.get("TARGET_DATABASE_NAME")
TARGET_TABLE_NAME = args.get("TARGET_TABLE_NAME")

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Script generated for node AWS Glue Data Catalog
AWSGlueDataCatalog_node1738074093224 = glueContext.create_dynamic_frame.from_catalog(database=SOURCE_DATABASE_NAME, table_name=SOURCE_TABLE_NAME, transformation_ctx="AWSGlueDataCatalog_node1738074093224")

# Script generated for node AWS Glue Data Catalog
AWSGlueDataCatalog_node1738074158971_df = AWSGlueDataCatalog_node1738074093224.toDF()
AWSGlueDataCatalog_node1738074158971 = glueContext.write_data_frame.from_catalog(frame=AWSGlueDataCatalog_node1738074158971_df, database=TARGET_DATABASE_NAME, table_name=TARGET_TABLE_NAME, additional_options={})

job.commit()