variable gcp_project_name {
  type = string
  default = "relaynet-pong-example"
}

provider "google" {
  project = var.gcp_project_name
  region = "us-central1"
  zone = "us-central1-c"

  version = "3.5"
}
