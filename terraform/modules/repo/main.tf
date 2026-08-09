# trivy:ignore:AVD-GIT-0003 (HIGH): Repository does not have vulnerability alerts enabled
resource "github_repository" "repo" {
  name        = var.name
  description = var.description

  allow_auto_merge    = false
  allow_merge_commit  = false
  allow_rebase_merge  = false
  allow_squash_merge  = true
  allow_update_branch = true

  archived           = false
  archive_on_destroy = false

  auto_init = true

  delete_branch_on_merge = true

  has_discussions = false
  has_issues      = true
  has_projects    = false
  has_wiki        = false

  gitignore_template = "Terraform"
  license_template   = "mit"

  # trivy:ignore:AVD-GIT-0001
  visibility = var.visibility
}

resource "github_branch_default" "default" {
  repository = github_repository.repo.name
  branch     = "main"
}

resource "github_repository_ruleset" "branch_protection" {
  repository  = github_repository.repo.name
  name        = "default"
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  rules {
    creation = false
    deletion = false
    update   = false

    non_fast_forward = true

    required_linear_history = false
    required_signatures     = false

    pull_request {
      dismiss_stale_reviews_on_push     = false
      require_code_owner_review         = false
      require_last_push_approval        = false
      required_approving_review_count   = 0
      required_review_thread_resolution = false
    }
  }
}

resource "github_repository_vulnerability_alerts" "vulnerability_alerts" {
  repository = github_repository.repo.name
  enabled    = true
}
