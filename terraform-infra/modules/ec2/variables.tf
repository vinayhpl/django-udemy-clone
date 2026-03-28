variable "vpc_id" {}
variable "subnet_id" {}

variable "ami_id" {}
variable "key_name" {}

variable "my_ip" {
  description = "i don't want restrict only for me for assignment"
  default     = "0.0.0.0/0"
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
}