locals {
  members = {
    chakrit       = "admin"
    iporsut       = "member"
    pistachiology = "member"
    zeing         = "member"
    phatograph    = "member"
    kanokorn      = "member"
    narze         = "member"
    zentetsukenz  = "member"
  }

  repositories = {
    "infra"   = "IaC for OpenVac",
    "openvac" = "Main openvac codebase",
  }
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
  permission = local.members[split(":", each.key)[0]] == "admin" ? "admin" : "push"
}

resource "github_repository_webhook" "public-repo-webhooks" {
  for_each   = local.repositories
  repository = github_repository.public-repos[each.key].name
  active     = true
  events     = ["push"]

  configuration {
    url          = "https://discord.com/api/webhooks/866340433637408800/bT0aZahu9WTUB3NNC_ie4cna22vkYIwgcnHtFgl4Ov12Sn2_IIuxb6gZtegjVqL7cOse/github"
    content_type = "form"
    insecure_ssl = false
  }
}
