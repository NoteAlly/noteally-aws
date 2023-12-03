import os
import json
import boto3
from dotenv import load_dotenv
load_dotenv()

if __name__=='__main__':

    # AWS Client
    client = boto3.client(
        service_name = 'amplify',
        region_name = os.environ.get('AWS_REGION_NAME'),
        aws_access_key_id = os.environ.get('AWS_ACCESS_KEY_ID'),
        aws_secret_access_key = os.environ.get('AWS_SECRET_ACCESS_KEY')
    )

    region = os.environ.get('AWS_REGION_NAME'),
    branch = os.environ.get('FRONTEND_BRANCH')

    with open('terraform.tfstate', 'rt') as f:
        data = json.load(f)
        tf_outputs = data['outputs']
        amplify_app_id = tf_outputs['amplify_app_id']['value']
        cognito_client_domain = tf_outputs['cognito_client_domain']['value']
        cognito_client_id = tf_outputs['cognito_client_id']['value']
        amplify_domain = tf_outputs['amplify_domain']['value']
        api_gateway_url = tf_outputs['api_gateway_url']['value']
    

    # Update env vars
    try:
        client.update_app(
            appId = amplify_app_id,
            
            environmentVariables = {
                "VITE_API_URL": f"{api_gateway_url}dev",
                "VITE_AUTH_LOGIN": f"https://{cognito_client_domain}.auth.{region}.amazoncognito.com/login?client_id={cognito_client_id}&response_type=token&scope=email+openid+profile&redirect_uri=https://{branch}.{amplify_domain}/login?",
                "VITE_AUTH_REGISTER": f"https://{cognito_client_domain}.auth.{region}.amazoncognito.com/signup?client_id={cognito_client_id}&response_type=token&scope=email+openid+profile&redirect_uri=https://{branch}.{amplify_domain}/login?",
                "VITE_AUTH_LOGOUT": f"https://{cognito_client_domain}.auth.{region}.amazoncognito.com/logout?client_id={cognito_client_id}&logout_uri=https://{branch}.{amplify_domain}",
            }
        )
    
    except Exception as e:
        print(e)


    # Run Build
    try:
        client.start_job(
            appId = amplify_app_id,
            branchName = branch,
            jobType = 'RELEASE'
        )

    except Exception as e:
        print(e)
