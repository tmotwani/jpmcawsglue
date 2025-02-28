# Iceberg Project

## Overview
This project manages AWS Glue jobs and related resources using Terraform and AWS CLI commands. It provides a streamlined workflow for deploying and managing Iceberg table operations through AWS Glue jobs.

## Prerequisites
- Terraform installed
- AWS CLI configured with appropriate credentials
- Make utility installed
- Python 3.x
- Valid AWS credentials and permissions

## Project Components
- Glue Python Scripts for data processing
- Iceberg runtime JAR files
- Sales data files
- Terraform infrastructure code

## Configuration
The project uses the following default configurations:
- Application Name: icy
- Environment: dev
- AWS Region: us-east-1

Please change the default value for "Environment" both in Makefile and Terraform.tfvars file to a unique value such as "dev1", "dev2", "dev7", "dev87", "devx", "devy" etc.

## Infrastructure Deployment

### Initialize Terraform
make init

### Plan Terraform changes
make plan

### Apply Terraform changes
make apply

## Scripts Deployment

make deploy-scripts

## Jars Deployment

make deploy-jars

## Data Deployment

make deploy-data

## Glue Job Operations

### Start Sales Job
make start-sales-job

### Create S3 Tables
make start-create-s3-job

### Process S3 Sales Job
make start-sales-s3-job

## Executing Athena Queries

In Athena, select "icy-workgroup" as workgroup

### To run queries against Iceberg Data Catalog created in standard S3 bucket

Select "AwsDataCatalog" as "Data Source"
Select "None" as "Catalog"
Select "icy_dev_-_sales" or equivalent as "Database"
You should see Tables show up "icy_dev_sales_data" and "icy_dev_sales_iceberg" or equivalent
Select "icy_dev_sales_iceberg", click on "..." to the right and select "Preview Table" to see the first 10 rows of the iceberg table

### To run queries against Iceberg Data Catalog created in Iceberg S3 bucket

Grant the role you have used to login to Athena permission in Lake Formation to the "S3tablescatalog". 
Run following query or equivalent in Athena. 

SELECT * FROM "s3tablescatalog/icy-dev-sales"."icy"."sales" limit 10

## Use Glue Crawler to create an Iceberg Glue Table

make start-glue-crawler
