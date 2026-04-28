variable "vpc_id" {
  description = "vpc_id"
  type        = string
}

variable "subnet_id" {
  description = "subnet_id"
  type        = string
}

variable "iam_instance_profile" {
  description = "iam_instance_profile"
  type        = string
}

variable "cidr_block" {
  description = "cidr_block"
  type        = string
}