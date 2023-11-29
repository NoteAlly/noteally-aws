terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  access_key = local.envs["AWS_ACCESS_KEY_ID"]
  secret_key = local.envs["AWS_SECRET_ACCESS_KEY"]
  token      = try(local.envs["AWS_SESSION_TOKEN"], null)
  region     = local.envs["AWS_REGION_NAME"]
}

terraform {
  required_version = ">= 0.12"
}
