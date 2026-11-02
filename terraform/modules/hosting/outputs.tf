output "site_id" {
  description = "Firebase Hosting site ID"
  value       = google_firebase_hosting_site.this.site_id
}

output "default_url" {
  description = "Firebase URL of the site, works before DNS is set up"
  value       = google_firebase_hosting_site.this.default_url
}

output "apex_dns_updates" {
  description = "DNS records to add in Cloudflare for the apex domain"
  value       = google_firebase_hosting_custom_domain.apex.required_dns_updates
}

output "www_dns_updates" {
  description = "DNS records to add in Cloudflare for www"
  value       = google_firebase_hosting_custom_domain.www.required_dns_updates
}
