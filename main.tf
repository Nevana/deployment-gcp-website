provider "google" {
  project = "playground-s-11-b0962ad6"
  region  = "us-central1"
  zone    = "us-central1-a"
}

provider "google-beta" {
  project = "playground-s-11-b0962ad6"
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_compute_instance" "this" {
  name                    = "debian09"
  machine_type            = "e2-small"
  metadata_startup_script = "apt update && apt -y install apache2 && echo '<html><body><p>Linux startup script added directly.</p></body></html>' > /var/www/html/index.html"
  #tags                    = ["http-server", "https-server"]
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

resource "google_compute_health_check" "this" {
  name               = "check-backend"
  check_interval_sec = 1
  timeout_sec        = 1
  tcp_health_check {
    port = "80"
  }
}

resource "google_compute_backend_service" "this" {
  name                  = "l7-xlb-backend-service"
  provider              = google-beta
  protocol              = "HTTP"
  port_name             = "http"
  load_balancing_scheme = "EXTERNAL"
  health_checks         = [google_compute_health_check.this.id]
  backend {
    group           = google_compute_instance_group.this.id
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}

resource "google_compute_global_address" "this" {
  name = "l7-xlb-static-ip"
}

resource "google_compute_global_forwarding_rule" "this" {
  name                  = "l7-xlb-forwarding-rule"
  provider              = google
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.this.id
  ip_address            = google_compute_global_address.this.id
}

resource "google_compute_target_http_proxy" "this" {
  name     = "l7-xlb-target-http-proxy"
  provider = google
  url_map  = google_compute_url_map.this.id
}

resource "google_compute_url_map" "this" {
  name            = "l7-xlb-url-map"
  provider        = google
  default_service = google_compute_backend_service.this.id
}

resource "google_compute_firewall" "this" {
  name          = "test-firewall"
  network       = "default"
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

}
