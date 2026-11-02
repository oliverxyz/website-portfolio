output "site_id" {
  description = "Firebase Hosting site ID"
  value       = module.hosting.site_id
}

output "default_url" {
  description = "Firebase URL of the site, works before DNS is set up"
  value       = module.hosting.default_url
}

output "apex_dns_updates" {
  description = "DNS records to add in Cloudflare for the apex domain"
  value       = module.hosting.apex_dns_updates
}

output "www_dns_updates" {
  description = "DNS records to add in Cloudflare for www"
  value       = module.hosting.www_dns_updates
}

output "workload_identity_provider" {
  description = "Provider name for the GitHub Actions auth step"
  value       = module.deploy_access.workload_identity_provider
}

output "service_account_email" {
  description = "Service account used by GitHub Actions"
  value       = module.deploy_access.service_account_email
}

output "phone_secret_id" {
  description = "Secret that holds the phone number"
  value       = module.deploy_access.phone_secret_id
}

output "private_bucket" {
  description = "Private bucket that holds the CV PDF"
  value       = module.deploy_access.private_bucket
}
