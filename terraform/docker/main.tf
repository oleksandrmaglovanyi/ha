terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.22.0"
    }
  }
}

provider "docker" {
}

resource "docker_image" "echo-server" {
  name = "echo-server"
  build {
    path = "../echo-server"
    tag  = ["echo-server:latest"]
  }
}

resource "docker_container" "echo-server" {
  name    = "echo-server"
  image   = docker_image.echo-server.image_id

  ports {
    external = 80
    internal = 3246
  }
}