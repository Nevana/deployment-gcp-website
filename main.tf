provider "google" {
  #credentials = file("../key.json")
  project = "playground-s-11-b0962ad6"
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_compute_instance" "this" {
  name                    = "debian09"
  machine_type            = "e2-small"
  metadata_startup_script = "apt update && apt -y install apache2 && echo '<html><body><p>Linux startup script added directly.</p></body></html>' > /var/www/html/index.html"
  tags                    = ["http-server", "https-server"]
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  network_interface {
    network = "default"
    access_config {
    }
  }
}

resource "google_compute_instance_group" "this" {
  name      = "instance-group"
  instances = [google_compute_instance.this.id]
  named_port {
    name = "http"
    port = "80"
  }
}
