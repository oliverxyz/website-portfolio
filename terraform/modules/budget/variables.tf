variable "project_id" {
  description = "GCP project the budget watches"
  type        = string
}

variable "billing_account" {
  description = "Billing account ID"
  type        = string
}

variable "amount" {
  description = "Monthly budget in whole currency units"
  type        = number
}

variable "currency" {
  description = "Currency code, must match the billing account"
  type        = string
}
