output "vpc_id" {
    description = "The ID of the VPC"
    value       = aws_vpc.noteally_vpc.id
}

output "public_subnet_id" {
    description = "The ID of the public subnet"
    value       = aws_subnet.noteally_public_subnet[0].id
}

output "private_subnet_id" {
    description = "The ID of the private subnet"
    value       = aws_subnet.noteally_private_subnet[0].id
}
