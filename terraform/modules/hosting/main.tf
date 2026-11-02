# Firebase Hosting site with HTTPS on the apex domain and a redirect from www.

terraform {
  required_providers {
    google-beta = {
      source = "hashicorp/google-beta"
    }
  }
}

resource "google_firebase_project" "this" {
  provider = google-beta
  project  = var.project_id
}

resource "google_firebase_hosting_site" "this" {
  provider = google-beta
  project  = google_firebase_project.this.project
  site_id  = var.project_id
}

# DNS is managed by hand in Cloudflare, so Terraform must not wait for it.
resource "google_firebase_hosting_custom_domain" "apex" {
  provider              = google-beta
  project               = google_firebase_project.this.project
  site_id               = google_firebase_hosting_site.this.site_id
  custom_domain         = var.domain
  wait_dns_verification = false
}

resource "google_firebase_hosting_custom_domain" "www" {
  provider              = google-beta
  project               = google_firebase_project.this.project
  site_id               = google_firebase_hosting_site.this.site_id
  custom_domain         = "www.${var.domain}"
  redirect_target       = google_firebase_hosting_custom_domain.apex.custom_domain
  wait_dns_verification = false
}
