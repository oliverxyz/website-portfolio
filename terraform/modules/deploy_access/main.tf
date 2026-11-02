# Lets GitHub Actions deploy without keys, and holds the data kept out of git:
# the phone number in Secret Manager and the CV PDF in a private bucket.
# Terraform creates only the containers, so the values never reach its state.

resource "google_service_account" "deployer" {
  project      = var.project_id
  account_id   = "github-deployer"
  display_name = "GitHub Actions deployer"
}

resource "google_iam_workload_identity_pool" "github" {
  project                   = var.project_id
  workload_identity_pool_id = "github"
  display_name              = "GitHub Actions"
}

resource "google_iam_workload_identity_pool_provider" "github" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "github"
  display_name                       = "GitHub Actions"

  # Numeric owner ID, because a GitHub login can be renamed and reused.
  attribute_condition = join(" && ", [
    "assertion.repository_owner_id == '${var.github_owner_id}'",
    "assertion.repository == '${var.github_repository}'",
    "assertion.ref == 'refs/heads/main'",
  ])

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
  }

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account_iam_member" "github_impersonation" {
  service_account_id = google_service_account.deployer.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository/${var.github_repository}"
}

resource "google_project_iam_member" "hosting_admin" {
  project = var.project_id
  role    = "roles/firebasehosting.admin"
  member  = google_service_account.deployer.member
}

# firebase-tools checks that the Hosting API is enabled before it deploys.
resource "google_project_iam_member" "service_usage_viewer" {
  project = var.project_id
  role    = "roles/serviceusage.serviceUsageViewer"
  member  = google_service_account.deployer.member
}

resource "google_secret_manager_secret" "phone" {
  project   = var.project_id
  secret_id = "resume-phone"

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_iam_member" "phone_reader" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.phone.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = google_service_account.deployer.member
}

resource "google_storage_bucket" "private" {
  project                     = var.project_id
  name                        = "${var.project_id}-private"
  location                    = var.region
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
}

resource "google_storage_bucket_iam_member" "private_reader" {
  bucket = google_storage_bucket.private.name
  role   = "roles/storage.objectViewer"
  member = google_service_account.deployer.member
}
