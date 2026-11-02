module "hosting" {
  source = "../../modules/hosting"

  project_id = var.project_id
  domain     = var.domain
}

module "deploy_access" {
  source = "../../modules/deploy_access"

  project_id        = var.project_id
  region            = var.region
  github_repository = var.github_repository
  github_owner_id   = var.github_owner_id
}

module "budget" {
  source = "../../modules/budget"

  project_id      = var.project_id
  billing_account = var.billing_account
  amount          = 30
  currency        = "EUR"
}
