terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.22.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

module "ec2" {
  source           = "./ec2"
  count            = var.local ? 0 : 1
  resources_prefix = var.prefix
}

module "docker" {
  source      = "./docker"
  count            = var.local ? 1 : 0
}