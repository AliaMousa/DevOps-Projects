terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.6.0"
    }
  }
}

provider "google" {
  # Configuration options
  project = "project_id"
  region = "us-east1"
  zone = "us-east1-c"
}