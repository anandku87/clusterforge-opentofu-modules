resource "google_service_account" "gsa" {
  account_id   = var.service_account_name
  display_name = var.service_account_display_name
  project      = var.project_id
}

resource "google_project_iam_member" "sa_roles" {
  for_each = toset(var.roles)

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.gsa.email}"
}

resource "google_service_account_iam_member" "workload_identity" {
  service_account_id = google_service_account.gsa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[${var.kubernetes_namespace}/${var.kubernetes_service_account}]"
}
