data "aws_caller_identity" "current" {}

# ── GitHub OIDC Provider ─────────────────────────────────────────────────────

resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]

  # GitHub's OIDC thumbprint — rotate if GitHub rotates their cert
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]

  tags = {
    Name    = "GitHubOIDCProvider"
    Project = "move2cloud-tn"
  }
}

# ── Trust policy: allow only the move2cloud-tn repo on main ─────────────────

data "aws_iam_policy_document" "github_runner_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.GITHUB_ORG}/${var.GITHUB_REPO}:ref:refs/heads/main"]
    }
  }
}

# ── GithubRunnerRole ─────────────────────────────────────────────────────────

resource "aws_iam_role" "github_runner" {
  name               = "GithubRunnerRole"
  assume_role_policy = data.aws_iam_policy_document.github_runner_trust.json

  tags = {
    Name    = "GithubRunnerRole"
    Project = "move2cloud-tn"
  }
}

# ── S3 deploy permissions ────────────────────────────────────────────────────

data "aws_iam_policy_document" "s3_deploy" {
  statement {
    sid    = "ListBucket"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]
    resources = ["arn:aws:s3:::${var.S3_BUCKET}"]
  }

  statement {
    sid    = "PutDeleteObjects"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:DeleteObject",
      "s3:GetObject",
    ]
    resources = ["arn:aws:s3:::${var.S3_BUCKET}/*"]
  }

  dynamic "statement" {
    for_each = var.CLOUDFRONT_DISTRIBUTION_ARN != "" ? [1] : []
    content {
      sid     = "CloudFrontInvalidation"
      effect  = "Allow"
      actions = ["cloudfront:CreateInvalidation"]
      resources = [var.CLOUDFRONT_DISTRIBUTION_ARN]
    }
  }
}

resource "aws_iam_role_policy" "github_runner_s3" {
  name   = "S3DeployPolicy"
  role   = aws_iam_role.github_runner.id
  policy = data.aws_iam_policy_document.s3_deploy.json
}

# ── Outputs ──────────────────────────────────────────────────────────────────

output "github_oidc_provider_arn" {
  value       = aws_iam_openid_connect_provider.github.arn
  description = "GitHub OIDC provider ARN"
}

output "github_runner_role_arn" {
  value       = aws_iam_role.github_runner.arn
  description = "ARN to use in role-to-assume in GitHub Actions"
}
