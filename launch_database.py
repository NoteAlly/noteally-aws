from database.rds import Database
from utils.vpc import VPC
from utils.security_group import SecurityGroup

import os
from dotenv import load_dotenv
load_dotenv()

def main(aws_access_key_id, aws_secret_access_key, aws_session_token, region_name):
    
    # Get the default vpc id
    vpc = VPC(aws_access_key_id, aws_secret_access_key, aws_session_token, region_name)
    default_vpc_id = vpc.get_default_vpc_id()
    
    # Create security group or use existing one and add inbound rules
    security_group = SecurityGroup(aws_access_key_id, aws_secret_access_key, aws_session_token, region_name)
    security_group_params = {
        'Description': 'Security group for Noteally Postgres DB',
        'GroupName': 'noteally-db-sg',
        'VpcId': default_vpc_id,
    }
    security_group.create_security_group(security_group_params)
    security_group.add_security_group_inbound(
        [
                {
                    'IpProtocol': '-1',  # All protocols
                    'FromPort': -1,
                    'ToPort': -1,
                    'IpRanges': [
                        {
                            'CidrIp': '0.0.0.0/0',
                            'Description': 'Allow all traffics',
                            }
                        ]
                }
            ]
        )
    
    
    # Create database instance
    database = Database(aws_access_key_id, aws_secret_access_key, aws_session_token, region_name)
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
        'VpcSecurityGroupIds': [security_group.get_security_group_id()],
        'Port': 5432,
        
        # Database authentication
        
        # Monitoring
        'EnablePerformanceInsights': True,
        
        # Aditional configuration
        'BackupRetentionPeriod': 1,
        'CopyTagsToSnapshot': True,
        'StorageEncrypted': True,
        'DeletionProtection': True,
        
    }
    
    database.create_database(db_instance_params)
    print("Getting db ip")
    response = database.get_database_endpoint()
    if response != None:
        print(f"Database: { database.get_database_id() } \nAddress: { response }\n")

if __name__ == '__main__':
    main(os.environ.get("aws_access_key_id"), os.environ.get("aws_secret_access_key"), os.environ.get("aws_session_token"), os.environ.get("region_name"))