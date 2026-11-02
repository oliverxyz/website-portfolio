output "state_bucket" {
  description = "Bucket for Terraform state"
  value       = google_storage_bucket.tfstate.name
}
