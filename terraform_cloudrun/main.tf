terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  credentials = file("/home/admin_/keys/tf-key-cloudrundemo.json")
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}


resource "google_cloud_run_service" "default" {
  name     = "abtest-service"
  location = var.region

  template {
    spec {
      containers {
        image = "gcr.io/cloudrun-demo-385011/cloudrun/abtest:latest"
        ports {
          container_port = "8080"
        }
        env {
          name  = "VERSION"
          value = var.app_version
        }
        env {
          name  = "COLOUR"
          value = var.colour
        }
      }
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.default.location
  project     = google_cloud_run_service.default.project
  service     = google_cloud_run_service.default.name
  policy_data = data.google_iam_policy.noauth.policy_data
}
