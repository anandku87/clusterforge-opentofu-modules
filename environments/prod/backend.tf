terraform {
  backend "gcs" {
    bucket = "clusterforge-state"
    prefix = "prod"
  }
}