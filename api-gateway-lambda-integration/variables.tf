variable "AWS_REGION" {
   default   = "us-east-1"
   #default = "eu-west-2"
  type      = string
  sensitive = true
}
variable "AWS_ACCOUNT_ID" {
  default   = "211125450414"
  type      = string
  sensitive = true
}
