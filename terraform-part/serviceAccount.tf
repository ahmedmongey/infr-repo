# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_service
resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
}

resource "google_project_service" "container" {
  service = "container.googleapis.com"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
resource "google_compute_network" "main" {
  name                            = "main"
  routing_mode                    = "REGIONAL"
  auto_create_subnetworks         = false
  mtu                             = 1460
  delete_default_routes_on_create = false

  depends_on = [
    google_project_service.compute,
    google_project_service.container
  ]
}

resource "google_service_account" "manage-sa" {
  account_id   = "manage-sa"
  display_name = "manage Service Account"
}

resource "google_compute_instance" "default" {
  name         = "test"
  machine_type = "e2-medium"
  zone         = "us-central1-a"


  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

 

  network_interface {
    network = "main"
    subnetwork = "private"

  
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.manage-sa.email
    scopes = ["cloud-platform"]
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
resource "google_service_account" "kubernetes" {
  account_id = "kubernetes"
}
