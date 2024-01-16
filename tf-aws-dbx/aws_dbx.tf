# Define the AWS provider
provider "aws" {
  region = "us-east-1" # Replace with your desired AWS region
}

# Module for creating VPCs
module "vpcs" {
  source = "./modules/vpcs"
  vpc1_cidr = "10.0.0.0/16"
  vpc2_cidr = "10.1.0.0/16"
}

# Module for creating IAM roles and policies for Databricks
module "databricks_iam" {
  source = "./modules/databricks_iam"
}

# Module for creating Databricks clusters
module "databricks_clusters" {
  source = "./modules/databricks_clusters"
  num_clusters = 3
  subnet_ids = module.vpcs.private_subnet_ids
  role_arn = module.databricks_iam.databricks_role_arn
}

# Create other AWS resources as needed (e.g., S3 buckets, Step Functions, EventBridge, etc.)

# Define outputs for relevant resource information
output "databricks_cluster_ids" {
  value = module.databricks_clusters.cluster_ids
}
