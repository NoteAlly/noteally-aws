#
# USER POOL
#

resource "aws_cognito_user_pool" "user_pool" {
  name = "user-pool"

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length = 6
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject        = "Account Confirmation"
    email_message        = "Your confirmation code is {####}"
  }

  # email
  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 1
      max_length = 100
    }
  }

  # given_name
  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "given_name"
    required                 = true

    string_attribute_constraints {
      min_length = 1
      max_length = 100
    }
  }

  # family_name
  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "family_name"
    required                 = true

    string_attribute_constraints {
      min_length = 1
      max_length = 100
    }
  }
}


#
# USER POOL DOMAIN
#

resource "aws_cognito_user_pool_domain" "user_pool_domain" {
  domain       = "noteally"
  user_pool_id = aws_cognito_user_pool.user_pool.id
}


#
# USER POOL CLIENT
#

resource "aws_cognito_user_pool_client" "userpool_client" {
  name          = "userpool-client"
  user_pool_id  = aws_cognito_user_pool.user_pool.id
  callback_urls = ["https://${local.envs["FRONTEND_BRANCH"]}.${aws_amplify_app.web_app.default_domain}"]
  logout_urls   = ["https://${local.envs["FRONTEND_BRANCH"]}.${aws_amplify_app.web_app.default_domain}/teste"]

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["implicit"]
  explicit_auth_flows                  = ["ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_SRP_AUTH"]
  allowed_oauth_scopes                 = ["email", "openid"]
  supported_identity_providers         = ["COGNITO"]
}
