# AWS Utils

This folder contains the utils used by the scripts to create the AWS infrastructure. This utils are aws tools that are not specific to any service, for example, the creation of security groups.

## Security Group

The security group class is a Python module designed to facilitate the creation and management of VPCs security groups. This class abstracts common security group related operations, making it easier to work with security groups.

### Security Group Methods

- create_security_group(security_group_params) - Creates a security group using the kwargs passed as parameters.
- _check_if_security_group_exists(security_group_name) - Checks if a security group with the same name already exists returning it if True.
- get_security_group_id() - Returns the security group id of the security group associated with the class if it exists.
- delete_security_group(security_group_id) - Deletes the security group with the id passed as parameter.
- add_security_group_inbound(ip_permissions) - Adds inbound rules to the security group associated with the class.
- add_security_group_outbound(ip_permissions) - Adds outbound rules to the security group associated with the class.
- remove_security_group_inbound(ip_permissions) - Removes inbound rules to the security group associated with the class.
- remove_security_group_outbound(ip_permissions) - Removes outbound rules to the security group associated with the class.
- check_if_ip_permissions_exists(ip_permissions) - Checks if the ip permissions passed as parameter already exists in the security group associated with the class.

### Security Group parameters

All possible parameters for a creation of a security group can be found in the file [security_group_params.md](security_group_params.md).

## VPC

The VPC class is a Python module designed to facilitate the creation and management of Amazon Virtual Private Clouds (VPCs). This class abstracts common VPC-related operations, making it easier to work with VPCs. Due to our needs, this class still only gets the default VPC id.

### VPC Methods

- get_default_vpc_id() - Returns the default VPC id.

### VPC parameters

All possible parameters for a creation of a VPC can be found in the file [vpc_params.md](vpc_params.md).
