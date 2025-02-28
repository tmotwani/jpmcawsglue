APP_NAME=icy
ENV_NAME=dev
AWS_PRIMARY_REGION=us-east-1

init: 
	terraform init

plan: 
	terraform plan

apply:
	terraform apply

deploy-scripts:
	@echo "Deploying Glue Scripts"
	(aws s3api put-object --bucket $(APP_NAME)-$(ENV_NAME)-glue-scripts --key sales.py --body sales.py --region $(AWS_PRIMARY_REGION); \
	 aws s3api put-object --bucket $(APP_NAME)-$(ENV_NAME)-glue-scripts --key s3_create_sales.py --body s3_create_sales.py --region $(AWS_PRIMARY_REGION); \
	 aws s3api put-object --bucket $(APP_NAME)-$(ENV_NAME)-glue-scripts --key s3_delete_sales.py --body s3_delete_sales.py --region $(AWS_PRIMARY_REGION); \
	 aws s3api put-object --bucket $(APP_NAME)-$(ENV_NAME)-glue-scripts --key s3_sales.py --body s3_sales.py --region $(AWS_PRIMARY_REGION);)
	@echo "Finished Deploying Glue Scripts"			

deploy-jars:
	@echo "Deploying Glue Jars"
	(aws s3api put-object --bucket $(APP_NAME)-$(ENV_NAME)-glue-jars --key s3-tables-catalog-for-iceberg-runtime-0.1.5.jar --body s3-tables-catalog-for-iceberg-runtime-0.1.5.jar --region $(AWS_PRIMARY_REGION);)
	@echo "Finished Deploying Glue Scripts"			

deploy-data:
	@echo "Deploying Data File"
	(aws s3api put-object --bucket $(APP_NAME)-$(ENV_NAME)-data --key sales.csv --body sales.csv --region $(AWS_PRIMARY_REGION);)
	@echo "Finished Deploying Data File"		

start-sales-job:
	@echo "Starting Sales Job"
	(aws glue start-job-run --region $(AWS_PRIMARY_REGION) --job-name $(APP_NAME)-$(ENV_NAME)-sales;)
	@echo "Started Sales Job"	

start-create-s3-job:
	@echo "Starting Sales S3 Create Job"
	(aws glue start-job-run --region $(AWS_PRIMARY_REGION) --job-name $(APP_NAME)-$(ENV_NAME)-sales-s3-create;)
	@echo "Started Sales S3 Create Job"	

start-delete-s3-job:
	@echo "Starting Sales S3 Create Job"
	(aws glue start-job-run --region $(AWS_PRIMARY_REGION) --job-name $(APP_NAME)-$(ENV_NAME)-sales-s3-delete;)
	@echo "Finshed Sales S3 Create Job"		

start-sales-s3-job:
	@echo "Starting Sales S3 Job"
	(aws glue start-job-run --region $(AWS_PRIMARY_REGION) --job-name $(APP_NAME)-$(ENV_NAME)-s3-sales;)
	@echo "Started Sales S3 Job"	

start-glue-crawler:
	@echo "Starting Glue Crawler"
	(aws glue start-crawler --region $(AWS_PRIMARY_REGION) --name $(APP_NAME)-$(ENV_NAME)-sales-crawler;)
	@echo "Started Glue Crawler"	