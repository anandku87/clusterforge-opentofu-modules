terraform {
  backend "gcs" {
    bucket = "clusterforge-state"
    prefix = "landing-zone"
  }
}