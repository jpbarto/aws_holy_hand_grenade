variable "aws_account_id" {
  description = "The target AWS account number"
  default = "123456789012"
}

variable "stack_name" {
  description = "The name prefix to be given to all created resources"
  default = "HHG"
}

variable "trigger_cost" {
  description = "When AWS spend for this account reaches this value, wipe the account"
  default = "5000"
}
