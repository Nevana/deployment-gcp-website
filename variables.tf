variable "project" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type    = string
  default = "us-central1-a"
}

variable "name" {
  type = string
}

variable "network" {
  type    = string
  default = "default"
}

variable "vm-type" {
  type    = string
  default = "e2-small"
}

variable "vm-startup-script" {
  type    = string
  default = "apt update && apt -y install apache2 && echo '<html><body><p>Linux startup script added directly.</p></body></html>' > /var/www/html/index.html"
}

variable "vm-image" {
  type    = string
  default = "debian-cloud/debian-9"
}

variable "backend-port" {
  type = number
}

variable "frontend-port" {
  type = number
}

variable "source-ranges" {
  type    = list(string)
  default = ["35.191.0.0/16", "130.211.0.0/22"]
}

variable "ip_protocol" {
  type    = string
  default = "tcp"
}


