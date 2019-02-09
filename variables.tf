variable "aws_account_id" {
  description = "The target AWS account number"
  default = "123456789012"
}

variable "aws_account_name" {
  description = "The alias or name of the AWS account"
  default = "jasbarto-dev"
}

variable "stack_name" {
  description = "The name prefix to be given to all created resources"
  default = "HHG"
}
