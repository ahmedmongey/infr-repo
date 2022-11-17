# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
resource "google_compute_subnetwork" "private" {
  name                     = "private"
  ip_cidr_range            = "10.0.0.0/24"
  region                   = "us-central1"
  network                  = google_compute_network.main.id
  private_ip_google_access = false

  
}

###################################################

resource "google_compute_subnetwork" "private-2" {
  name                     = "private-2"
  ip_cidr_range            = "10.0.5.0/24"
  region                   = "us-central1"
  network                  = google_compute_network.main.id
  private_ip_google_access = false

}