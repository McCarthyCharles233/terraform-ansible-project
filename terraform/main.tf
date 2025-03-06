provider "google" {
  project = "general-452601"
  region  = "us-central1"
}

resource "google_compute_instance" "web_server" {
  name         = "web-server"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11" 
    }
  }

  network_interface {
    network = "default"
    access_config {} 
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}" 
  }
}

resource "google_compute_firewall" "web_firewall" {
  name    = "web-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

output "instance_ip" {
  value = google_compute_instance.web_server.network_interface[0].access_config[0].nat_ip
}