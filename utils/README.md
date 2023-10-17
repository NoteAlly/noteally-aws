# AWS utils

This folder contains the utils used by the scripts to create the AWS infrastructure. This utils are aws tools that are not specific to any service, for example, the creation of security groups.

## Security group

The security group class is a Python module designed to facilitate the creation and management of VPCs security groups. This class abstracts common security group related operations, making it easier to work with security groups.

### Security Group parameters

All possible parameters for a creation of a security group can be found in the file [security_group_params.md](security_group_params.md).

## VPC

The VPC class is a Python module designed to facilitate the creation and management of Amazon Virtual Private Clouds (VPCs). This class abstracts common VPC-related operations, making it easier to work with VPCs. Due to our needs, this class still only gets the default VPC id.

## VPC parameters

All possible parameters for a creation of a VPC can be found in the file [vpc_params.md](vpc_params.md).
