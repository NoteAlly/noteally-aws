import time
import boto3

class Database:
    # __init__ should receive the aws_access_key_id=aws_access_key_id, aws_secret_access_key=aws_secret_access_key, aws_session_token=aws_session_token, region_name=region_name
    def __init__(self, aws_access_key_id, aws_secret_access_key, aws_session_token, region_name):
        self.client = boto3.client(
            'rds',
            aws_access_key_id=aws_access_key_id,
            aws_secret_access_key=aws_secret_access_key,
            aws_session_token=aws_session_token,
            region_name=region_name
        )
        self._database = None
    
    def create_database(self, database_params):
        self._database = self._check_if_database_exists(database_params['DBInstanceIdentifier'])
        
        if not self._database:
            self._database = self.client.create_db_instance(**database_params)['DBInstance']
        else:
            print("Database already exists\n")
        
        return self._database
    
    def _check_if_database_exists(self, database_name):
        response = self.client.describe_db_instances(
            Filters=[
                {
                    'Name': 'db-instance-id',
                    'Values': [
                        database_name,
                    ]
                },
            ],
        )
        
        if len(response['DBInstances']) > 0:
            return response['DBInstances'][0]
        
        return None
    
    def get_database_id(self):
        if self._database != None:
            return self._database['DBInstanceIdentifier']
        
        print("Database does not exist\n")
        return None
    
    def get_database_endpoint(self):
        if self._database != None:
            while True:
                self._database = self._check_if_database_exists(self._database['DBInstanceIdentifier'])
                if 'Endpoint' not in self._database.keys() or 'Address' not in self._database['Endpoint'].keys() or 'Port' not in self._database['Endpoint'].keys():
                    time.sleep(6)
                else:
                    break
                
            return self._database['Endpoint']['Address'] + ':' + str(self._database['Endpoint']['Port'])
        
        print("Database does not exist\n")
        return None