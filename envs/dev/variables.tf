variable "gcp_project_id" {
  description = "The GCP Project ID"
  type        = string
}

variable "default_region" {
  description = "The default GCP region"
  type        = string
  default     = "us-central1"
}
