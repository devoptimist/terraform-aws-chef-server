variable "name" {
  type    = "string"
}

variable "name_array" {
  type    = "list"
  default = []
}

variable "chef_user" {
  type    = "string"
  default = "chefuser"
}

variable "chef_pass" {
  type    = "string"
  default = "P@55word1"
}

variable "chef_org" {
  type    = "string"
  default = "cheforg"
}

variable "chef_server_version" {
  type    = "string"
  default = "12.19.31"
}

variable "chef_org_pem" {
  type    = "string"
  default = "/tmp/cheforg-validator.pem"
}

variable "chef_user_pem" {
  type    = "string"
  default = "/tmp/chefuser.pem"
}

variable "instance_count" {
  default = 1
}

variable "associate_public_ip_address" {
  default = true
}

variable "ami" {
  type = "string"
}

variable "instance_type" {
  type    = "string"
  default = "t2.medium"
}

variable "key_name" {
  type = "string"
}

variable "vpc_security_group_ids" {
  type = "list"
}

variable "subnet_ids" {
  type = "list"
}

variable "root_disk_size" {
  default = 40
}

variable "tags" {
  type    = "map"
  default = {}
}
