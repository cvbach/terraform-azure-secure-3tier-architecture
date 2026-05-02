variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type        = string
}

variable "is_public" {
  type = bool
}

variable "subnet_id" {
  type = string
  default = null
}

variable "frontend_private_ip" {
  type    = string
  default = null
}