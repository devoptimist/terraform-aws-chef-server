variable "name" {
  type    = "string"
}

variable "chef_server_cookbook_repo" {
  type    = "string"
  default = "https://github.com/devoptimist/chef_server_wrapper.git"
}
variable "chef_server_cookbook_github_path" {
  type    = "string"
  default = "devoptimist/chef_server_wrapper"
}

variable "create_system_user" {
  default = true
}

variable "system_user_name" {
  type    = "string"
  default = "chefuser"
}

variable "system_user_pass" {
  type    = "string"
  default = "P@55w0rd1"
}

variable "chef_bootstrap_product" {
  type    = "string"
  default = "chef-workstation"
}

variable "chef_bootstrap_version" {
  type    = "string"
  default = "0.3.2"
}

variable "system_user_public_ssh_key" {
  type    = "string"
  default = ""
}

variable "chef_server_users" {
  default = {
    "jdoe" = {
      "serveradmin"   = true
      "first_name"    = "Jane"
      "last_name"     = "Doe"
      "email"         = "jdoe@mycompany.com"
      "password"      = "P@55w0rd1"
    }
  }
}

variable "chef_server_orgs" {
  default = {
    "chef-org" = {
      "admins"        = ["jdoe"]
      "org_full_name" = "My Chef Organization"
    }
  }
}

variable "chef_server_channel" {
  type    = "string"
  default = "stable"
}

variable "chef_server_version" {
  type    = "string"
  default = "12.19.31"
}

variable "chef_server_accept_license" {
  default = true
}

variable "chef_server_data_collector_url" {
  type    = "string"
  default = ""
}

variable "chef_server_data_collector_token" {
  type    = "string"
  default = ""
}

variable "chef_server_config" {
  type    = "string"
  default = ""
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

variable "subnet_id" {
  type = "string"
}

variable "root_disk_size" {
  default = 40
}

variable "tags" {
  default = {}
}

variable "tmp_path" {
  default = "/var/tmp"
}
