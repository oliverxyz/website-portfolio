variable "project_id" {
  description = "GCP project that hosts the site"
  type        = string
}

variable "region" {
  description = "Region for the secret and the private bucket"
  type        = string
}

variable "github_repository" {
  description = "Repository allowed to deploy, as owner/name"
  type        = string
}

variable "github_owner_id" {
  description = "Numeric GitHub ID of the repository owner"
  type        = string
}
