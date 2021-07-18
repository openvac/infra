terraform {
  backend "remote" {
    organization = "openvac"

    workspaces {
      name = "infra"
    }
  }

  required_providers {
    github = {
      source  = "integrations/github"
      version = "4.12.2"
    }
  }
}

variable "github_token" {
  type = string
}

provider "github" {
  token = var.github_token
}


resource "github_repository" "infra" {
  name        = "infra"
  description = "IaC for OpenVac"
  visibility  = "public"

  template {
    owner      = "openvac"
    repository = "infra"
  }
}
