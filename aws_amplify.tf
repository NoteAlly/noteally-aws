#
# AWS AMPLIFY
#

resource "aws_amplify_app" "web_app" {
  name         = "noteally web app"
  platform     = "WEB"
  repository   = local.envs["FRONTEND_REPO"]
  access_token = local.envs["FRONTEND_ACCE"]

  build_spec = <<-EOT
        version: 1
        frontend:
            phases:
                preBuild:
                    commands:
                        - npm ci
                build:
                    commands:
                        - npm run build
            artifacts:
                baseDirectory: build
                files:
                    - '**/*'
            cache:
                paths:
                    - node_modules/**/*
  EOT
}


resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.web_app.id
  branch_name = local.envs["FRONTEND_BRANCH"]
}


resource "aws_amplify_webhook" "main" {
  app_id      = aws_amplify_app.web_app.id
  branch_name = aws_amplify_branch.main.branch_name
  description = "triggered by github push"
}
