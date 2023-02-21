variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
}

variable "ami" {
  description = "Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type"
  type        = string
}

variable "region" {
  description = "my aws region"
  type        = string

}

variable "bucket_name" {
  description = "my s3 bucket name"
  type        = string
}

variable "instance_type" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "username" {
  type = string
}
variable "keyname" {
  type = string
}