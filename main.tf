terraform {
  backend "remote" {
    organization = "openvac"

    workspaces {
      name = "infra"
    }
  }

  required_providers {
    github = {
      source = "integrations/github"
      version = "4.12.2"
    }
  }
}

provider "github" {}
