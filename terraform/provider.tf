/*terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.6.0"
    }
  }
}*/

provider "google"{
  project = "your-project-id"
  region = "us-east1"
  zone = "us-east1-c"
}