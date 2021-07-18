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
    # for M1 machines, replace with this block:
    # discord = {
    #   source  = "chakrit/discord"
    #   version = "0.0.1"
    # }
    discord = {
      source  = "aequasi/discord"
      version = "0.0.4"
    }
  }
}

variable "github_token" {
  type = string
}
variable "discord_token" {
  type = string
}

provider "github" {
  token = var.github_token
  owner = "openvac"
}

provider "discord" {
  token = var.discord_token
}
