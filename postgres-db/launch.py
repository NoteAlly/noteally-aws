import os
import boto3
from dotenv import load_dotenv

load_dotenv()  # take environment variables from .env.


def main(aws_access_key_id, aws_secret_access_key, aws_session_token, region_name):
    # Initialize the client
    client = create_client('rds', aws_access_key_id, aws_secret_access_key, aws_session_token, region_name)
    
    # Print VPCs
    # client2 = create_client('ec2', aws_access_key_id, aws_secret_access_key, aws_session_token, region_name)
    # response = client2.describe_vpcs()
    # print(response)
    
    db_instance_params = {
        
        # Engine Options
        'Engine': 'postgres',  # PostgreSQL
        'EngineVersion': '15.3',
        
        # Availability and durability
        'MultiAZ': False,
        
        # Settings
        'DBInstanceIdentifier': 'noteally-db-1',
        'DBName': 'noteally',
        'MasterUsername': 'postgres',
        'MasterUserPassword': 'postgres',
        
        # Instance configuration
        'DBInstanceClass': 'db.t3.micro',
        
        # Storage
        'StorageType': 'gp2',
        'AllocatedStorage': 20,
        
        # Connectivity
        'PubliclyAccessible': True,
        # 'DBSubnetGroup': {
        #     'VpcId': 'string',
        #     'DBSubnetGroupName': 'default',
        # },
        # 'VPCSecurityGroups': ['your-security-group-id'],
        'Port': 5432,
        
        # Database authentication
        
        # Monitoring
        'BackupRetentionPeriod': 7,
        
        # Aditional configuration
        
    }
    
    # Create database instance
    response = client.create_db_instance(**db_instance_params)
    
    
    
    
    
    
    
    

def create_client(svc: str, aws_access_key_id: str, aws_secret_access_key: str, aws_session_token: str, region_name: str):
    return boto3.client(
        svc,
        aws_access_key_id=aws_access_key_id,
        aws_secret_access_key=aws_secret_access_key,
        aws_session_token=aws_session_token,
        region_name=region_name
    )
    
    

if __name__ == '__main__':
    main(os.environ.get("aws_access_key_id"), os.environ.get("aws_secret_access_key"), os.environ.get("aws_session_token"), os.environ.get("region_name"))