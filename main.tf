resource "local_file" "hello" {
  filename = "${path.module}/hello.txt"
  content  = "OpenTofu is working on Ubuntu!"
}

output "hello" {
  value = local_file.hello.content
}

terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {}

variable "container_name" {
  default = "tofu-test-nginx"
}

variable "external_port" {
  default = 8080
}

variable "image_name" {
  default = "nginx:latest"
}

variable "memory_mb" {
  default = 512
}

variable "cpu_limit" {
  default = "1.0"
}

resource "docker_image" "nginx" {
  name = var.image_name
}

resource "docker_container" "web" {
  name   = var.container_name
  image  = docker_image.nginx.image_id
  memory = var.memory_mb
  cpus   = var.cpu_limit

  ports {
    internal = 80
    external = var.external_port
  }
}
