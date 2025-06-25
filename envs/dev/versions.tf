
terraform {
  required_version = ">= 1.3.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.70.0"
    }
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.default_region
}
