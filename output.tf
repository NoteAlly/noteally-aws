#
# AWS AMPLIFY
#

output "amplify_app_id" {
  value       = aws_amplify_app.web_app.id
  description = "AWS Amplify App ID"
}

output "amplify_domain" {
  value       = aws_amplify_app.web_app.default_domain
  description = "AWS Amplify Domain"
}


#
# AWS API GATEWAY
#

output "api_gateway_url" {
  value       = aws_api_gateway_deployment.api_deployment.invoke_url
  description = "API Gateway URL"
}


#
# AWS COGNITO
#

output "cognito_client_id" {
  value       = aws_cognito_user_pool_client.userpool_client.id
  description = "Cognito Client ID"
}

output "cognito_client_domain" {
  value       = aws_cognito_user_pool_domain.user_pool_domain.domain
  description = "Cognito Client Domain"
}

output "cognito_callback_url" {
  value       = aws_cognito_user_pool_client.userpool_client.callback_urls
  description = "Cognito Callback URL"
  sensitive   = true
}

output "cognito_logout_url" {
  value       = aws_cognito_user_pool_client.userpool_client.logout_urls
  description = "Cognito Logout URL"
  sensitive   = true
}


#
# AWS RDS - POSTGRES
#

output "rds_endpoint" {
  value       = aws_db_instance.postgres_db.endpoint
  description = "RDS Endpoint"
}


#
# AWS NLB
#

output "nlb_dns" {
  value       = aws_lb.network_load_balancer.dns_name
  description = "NLB DNS"
}
