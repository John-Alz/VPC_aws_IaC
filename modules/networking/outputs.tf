output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.main_vpc.cidr_block
}

output "private_subnet_ids" {
  value = aws_subnet.nequi_subnet_private[*].id
}