import boto3

class VPC:
    # __init__ should receive the aws_access_key_id=aws_access_key_id, aws_secret_access_key=aws_secret_access_key, aws_session_token=aws_session_token, region_name=region_name
    def __init__(self, aws_access_key_id, aws_secret_access_key, aws_session_token, region_name):
        self.client = boto3.client(
            'ec2',
            aws_access_key_id=aws_access_key_id,
            aws_secret_access_key=aws_secret_access_key,
            aws_session_token=aws_session_token,
            region_name=region_name
        )
        self._vpc = None
    
    
    def get_default_vpc_id(self):
        # Get the default VPC
        response = self.client.describe_vpcs(
            Filters=[
                {
                    'Name': 'isDefault',
                    'Values': [
                        'true',
                    ]
                },
            ],
        )
        
        if len(response) > 0:
            return response['Vpcs'][0]['VpcId']
        
        print("No default VPC found\n")