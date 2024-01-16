variable "num_clusters" {}
variable "subnet_ids" {}
variable "role_arn" {}

resource "databricks_cluster" "medallion_clusters" {
  count                   = var.num_clusters
  cluster_name            = "medallion-cluster-${count.index + 1}"
  spark_version           = "7.0.x-scala2.12"
  node_type_id            = "i3.xlarge"
  num_workers             = 2
  aws_attributes {
    instance_profile_arn = var.role_arn
    subnet_id            = element(var.subnet_ids, count.index % 2)
  }
}

output "cluster_ids" {
  value = databricks_cluster.medallion_clusters[*].id
}
