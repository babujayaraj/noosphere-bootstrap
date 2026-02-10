resource "aws_iam_policy" "github_actions_ci" {
  name        = "github-actions-ci-policy"
  description = "Least-privilege permissions for GitHub Actions CI pipeline"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ContainerBuildAndPush"
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage"
        ]
        Resource = "*"
      },
      {
        Sid    = "TerraformStateAccess"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "arn:aws:s3:::devops-tech-test-*/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_actions_ci_attach" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions_ci.arn
}
