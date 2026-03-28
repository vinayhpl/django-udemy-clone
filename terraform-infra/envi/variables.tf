variable "region" {
  description = "mumbai"
  default     = "ap-south-1"
}

variable "ami_id" {
  default = "ami-05d2d839d4f73aafb"
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
  default     = "tummoc-key-pair"
}

