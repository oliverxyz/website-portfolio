variable "project_id" {
  description = "GCP project that hosts the site"
  type        = string
  default     = "resume-website-513516"
}

variable "region" {
  description = "Region for the secret and the private bucket"
  type        = string
  default     = "europe-southwest1"
}

variable "domain" {
  description = "Apex domain of the site"
  type        = string
  default     = "oliverolsson.xyz"
}

variable "github_repository" {
  description = "Repository allowed to deploy, as owner/name"
  type        = string
  default     = "oliverxyz/website-portfolio"
}

variable "github_owner_id" {
  description = "Numeric GitHub ID of the repository owner"
  type        = string
  default     = "66230833"
}

variable "billing_account" {
  description = "Billing account ID, set in terraform.tfvars, which git ignores"
  type        = string
}
