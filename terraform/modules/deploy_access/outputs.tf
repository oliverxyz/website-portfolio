output "workload_identity_provider" {
  description = "Provider name for the GitHub Actions auth step"
  value       = google_iam_workload_identity_pool_provider.github.name
}

output "service_account_email" {
  description = "Service account used by GitHub Actions"
  value       = google_service_account.deployer.email
}

output "phone_secret_id" {
  description = "Secret that holds the phone number"
  value       = google_secret_manager_secret.phone.secret_id
}

output "private_bucket" {
  description = "Private bucket that holds the CV PDF"
  value       = google_storage_bucket.private.name
}
