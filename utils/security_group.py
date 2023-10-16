import sys
import boto3

class SecurityGroup:
    # __init__ should receive the aws_access_key_id=aws_access_key_id, aws_secret_access_key=aws_secret_access_key, aws_session_token=aws_session_token, region_name=region_name
    def __init__(self, aws_access_key_id, aws_secret_access_key, aws_session_token, region_name):
        self.client = boto3.client(
            'ec2',
            aws_access_key_id=aws_access_key_id,
            aws_secret_access_key=aws_secret_access_key,
            aws_session_token=aws_session_token,
            region_name=region_name
        )
        self.security_group = None
    
    def create_security_group(self, security_group_params):
        
        self.security_group = self._check_if_security_group_exists(security_group_params['GroupName'])
        
        if not self.security_group:
        
            self.security_group = self.client.create_security_group(**security_group_params)
        
        else:
            print("Security group already exists\n")
        
        return self.security_group
    
    
    def _check_if_security_group_exists(self, security_group_name):
        response = self.client.describe_security_groups(
            Filters=[
                {
                    'Name': 'group-name',
                    'Values': [
                        security_group_name,
                    ]
                },
            ],
        )
        
        if len(response['SecurityGroups']) > 0:
            return response['SecurityGroups'][0]
        
        return None
    
    def get_security_group_id(self):
        if self.security_group != None:
            return self.security_group['GroupId']
        
        print("Security group does not exist\n")
        return None
        
        
    def delete_security_group(self, security_group_id):
        if self.security_group != None:
            self.client.delete_security_group(
                GroupId=security_group_id
            )
        else:
            print("Security group does not exist\n")
        
    
    def add_security_group_inbound(self, ip_permissions):
        try:
            if self.security_group != None:
                self.client.authorize_security_group_ingress(
                    GroupId=self.security_group['GroupId'],
                    IpPermissions=ip_permissions
                )
        except Exception as e:
            if e.response['Error']['Code'] == 'InvalidPermission.Duplicate':
                print("Inbound security rule already exists\n")
            else:
                raise e
    
    def add_security_group_outbound(self, ip_permissions):
        try:
            if self.security_group != None:
                self.client.authorize_security_group_egress(
                    GroupId=self.security_group['GroupId'],
                    IpPermissions=ip_permissions
                )
        except Exception as e:
            if e.response['Error']['Code'] == 'InvalidPermission.Duplicate':
                print("Outbound security rule already exists\n")
            else:
                raise e
            
    
    def remove_security_group_inbound(self, ip_permissions):
        if self.check_if_ip_permissions_exists(ip_permissions):
            self.client.revoke_security_group_ingress(
                GroupId=self.security_group['GroupId'],
                IpPermissions=ip_permissions
            )
        else:
            print("Inbound security rule does not exist\n")
    
    
    def remove_security_group_outbound(self, ip_permissions):
        if self.check_if_ip_permissions_exists(ip_permissions):
            self.client.revoke_security_group_egress(
                GroupId=self.security_group['GroupId'],
                IpPermissions=ip_permissions
            )
        else:
            print("Outbound security rule does not exist\n")
    
    
    def check_if_ip_permissions_exists(self, ip_permissions):
        if self.security_group != None:
            response = self.client.describe_security_groups(
                GroupIds=[
                    self.security_group['GroupId'],
                ],
            )
            
            for ip_permission in response['SecurityGroups'][0]['IpPermissions']:
                if ip_permission == ip_permissions:
                    return True
            
            return False