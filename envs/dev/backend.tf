
terraform {
  backend "gcs" {
    bucket = "mlops-project-462702-tfstate"
    prefix = "terraform/state/dev"
  }
}
