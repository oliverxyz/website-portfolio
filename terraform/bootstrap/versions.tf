terraform {
  required_version = ">= 1.16"

  # The bucket is created by this configuration, so the first apply ran with
  # local state, which was then moved here with `terraform init -migrate-state`.
  backend "gcs" {
    bucket = "resume-website-513516-tfstate"
    prefix = "bootstrap"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 8.9"
    }
  }
}

provider "google" {
  project               = var.project_id
  region                = var.region
  user_project_override = true
  billing_project       = var.project_id
}
