data "terraform_remote_state" "landing_zone" {
  backend = "local"

  config = {
    path = "../landing-zone/terraform.tfstate"
  }
}