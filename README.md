# Important
This module creates a chef server and a user in an orgganization on that chef server.
Currently only supports RHEL 7 compatible images.

## Usage

```hcl

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "1.64.0"

  name = "chef-server-vpc"
  cidr = "10.0.0.0/16"

  azs            = ["eu-west-2a"]
  public_subnets = ["10.0.1.0/24"]
  map_public_ip_on_launch = true
  tags = "${var.tags}"
}

module "sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "2.17.0"

  name        = "chef-server-security-group"
  description = "security group to enable ssh"
  vpc_id      = "${module.vpc.vpc_id}"
  ingress_rules       = ["ssh-tcp"]
  egress_rules        = ["all-all"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
}

data "aws_ami" "chef_server_image" {
  most_recent = true
  owners      = ["309956199498"]

  filter {
    name   = "name"
    values = ["RHEL-7.6_HVM_GA-20190128-x86_64-0-Hourly2-GP2"]
  }
}

module "chef_server" {
  source                      = "devoptimist/chef-server/aws"
  version                     = "0.1.16"
  name                        = "chef-server" 
  chef_user                   = "mike"
  chef_pass                   = "P@55w0rd1"
  chef_org                    = "org1"
  chef_server_version         = "12.19.44"
  chef_org_pem                = "/tmp"
  chef_user_pem               = "/tmp"
  instance_count              = 1
  associate_public_ip_address = true
  ami                         = "${module.chef_server_image.ami_id}"
  instance_type               = "t2.medium"
  key_name                    = "my_aws_key"
  vpc_security_group_ids      = ["${module.sg.this_security_group_id}"]
  subnet_ids                  = ["${module.vpc.public_subnets}"]
  root_disk_size              = 40
  tags                        = "${var.tags}"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
|name|The name to give the chef server instnace Name tag|string||yes|
|chef_user| The name of the use to create on the chef server | string | chefuser | no |
|chef_pass|The password for the chef user | string | P@55w0rd1 | no|
|chef_org|The name of the organization to create on the chef server | string | cheforg | no|
|chef_server_version|The version of chef server to install| string |12.19.44| no|
|chef_org_pem|The path to write the validator pem file to| string |/tmp| no|
|chef_user_pem|The path to write the user pem to| string |/tmp| no|
|instance_count|The number of identical chef servers to create|int|1|no|
|associate_public_ip_address|Should the chef server have a public ip|bool|true|no|
|ami|The ami id to create the chef server from|string||yes|
|instance_type|The aws instance size to create the chef server from|string|t2.medium|no|
|key_name|The name of aws ssh key to associate with this instance|string||yes|
|vpc_security_group_ids|A list of security group ids to associage with this instance|list||yes|
|subnet_ids|A list of subnet ids to associate with this instance|list||yes|
|root_disk_size|The size (in GB) of the root disk for the chef server|string|40|no|
|tags|A map of tags to associate with the instance|map|{}|no|
