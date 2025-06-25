
module "gcs" {
  source      = "../../modules/gcs"
  bucket_name = "${var.gcp_project_id}-dev-bucket"
}

module "bigquery" {
  source     = "../../modules/bigquery"
  dataset_id = "dev_dataset"
}

module "workbench" {
  source        = "../../modules/vertex_workbench"
  instance_name = "dev-notebook"
  location      = "${var.default_region}-a"
}

module "cloud_run" {
  source       = "../../modules/cloud_run"
  service_name = "dev-cloudrun"
  region       = var.default_region
  image        = "us-docker.pkg.dev/cloudrun/container/hello"
}

module "endpoint" {
  source        = "../../modules/vertex_endpoint"
  endpoint_name = "dev-endpoint"
  region        = var.default_region
}
