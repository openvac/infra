locals {
  members = {
    chakrit       = "admin"
    iporsut       = "member"
    pistachiology = "member"
    zeing         = "member"
    phatograph    = "member"
  }

  repositories = {
    "infra"   = "IaC for OpenVac",
    "openvac" = "Main openvac codebase",
  }
}

resource "github_membership" "admins" {
  for_each = local.admins
  username = each.key
  role     = "admin"
}

resource "github_membership" "members" {
  for_each = local.members
  username = each.key
  role     = each.value
}

resource "github_repository" "public-repos" {
  for_each = local.repositories

  name        = each.key
  description = each.value
  visibility  = "public"
  is_template = false
  auto_init   = false

  has_issues    = true
  has_projects  = false
  has_wiki      = false
  has_downloads = false

  allow_merge_commit     = false
  allow_squash_merge     = false
  allow_rebase_merge     = true
  delete_branch_on_merge = true
}

resource "github_branch" "main-branches" {
  for_each   = local.repositories
  repository = each.key
  branch     = "main"
}

resource "github_branch_default" "default-branches" {
  for_each   = local.repositories
  repository = each.key
  branch     = "main"
}

resource "github_repository_collaborator" "public-repo-collabs" {
  for_each = toset(flatten([
    for member, _ in local.members : [
      for repo, _ in local.repositories :
      "${member}:${repo}"
    ]
  ]))

  username   = split(":", each.key)[0]
  repository = split(":", each.key)[1]
  permission = local.members[each.key] == "admin" ? "admin" : "push"
}
