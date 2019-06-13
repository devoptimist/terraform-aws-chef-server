locals {
  chef_users = jsonencode(var.chef_server_users)
  chef_orgs  = jsonencode(var.chef_server_orgs)
  bootstrap  = templatefile("${path.module}/templates/bootstrap.sh", {
    create_system_user         = var.create_system_user,
    system_user_name           = var.system_user_name,
    system_user_pass           = var.system_user_pass,
    system_user_public_ssh_key = var.system_user_public_ssh_key
  })
  first_boot = templatefile("${path.module}/templates/first_boot.json", {
    channel                    = var.chef_server_channel,
    version                    = var.chef_server_version,
    accept_license             = var.chef_server_accept_license,
    data_collector_url         = var.chef_server_data_collector_url,
    data_collector_token       = var.chef_server_data_collector_token,
    starter_pack_user          = var.chef_server_starter_pack_user,
    starter_pack_org           = var.chef_server_starter_pack_org,
    starter_pack_path          = var.chef_server_starter_pack_location,
    starter_pack_knife_rb_path = var.chef_server_starter_pack_knife_rb_path,
    config                     = var.chef_server_config,
    chef_users                 = local.chef_users,
    chef_orgs                  = local.chef_orgs
  })
}

module "chef_server" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "2.0.0"
  name                        = "${var.name}"
  instance_count              = var.instance_count
  ami                         = var.ami
  instance_type               = var.instance_type
  associate_public_ip_address = var.associate_public_ip_address
  key_name                    = var.key_name
  monitoring                  = true
  vpc_security_group_ids      = var.vpc_security_group_ids
  subnet_id                   = var.subnet_id
  root_block_device = [{
    volume_type = "gp2"
    volume_size = var.root_disk_size
  }]
  tags                        = var.tags
  user_data                   = local.bootstrap

}

resource "null_resource" "chef_run" {

  connection {
    user        = var.system_user_name
    password    = var.system_user_pass
    host        = "${module.chef_server.public_ip[0]}"
  }

  provisioner "file" {
    source      = "${path.module}/files/Policyfile.rb"
    destination = "${var.tmp_path}/Policyfile.rb"
  }

  provisioner "file" {
    content     = local.first_boot
    destination = "${var.tmp_path}/first-boot.json"
  }

  provisioner "remote-exec" {
    inline = [
      "curl -LO https://www.chef.io/chef/install.sh && sudo bash ./install.sh -P ${var.chef_bootstrap_product} -v ${var.chef_bootstrap_version}",
      "chef install ${var.tmp_path}/Policyfile.rb",
      "chef export ${var.tmp_path}/Policyfile.rb . -a",
      "mv chef_server_wrapper-*.tgz ${var.tmp_path}/cookbooks.tgz",
      "sudo chef-solo --recipe-url ${var.tmp_path}/cookbooks.tgz -j ${var.tmp_path}/first-boot.json --chef-license accept"
    ]
  }
  depends_on = ["module.chef_server"]
}

resource "null_resource" "starter_pack" {

  connection {
    user        = var.system_user_name
    password    = var.system_user_pass
    host        = "${module.chef_server.public_ip[0]}"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /tmp/chef-repo/.chef",
      "mkdir -p /tmp/chef-repo/cookbooks",
      "mkdir -p /tmp/chef-repo/policies",
      "sudo cp /etc/opscode/users/${var.chef_server_starter_pack_user}.pem /tmp/chef-repo/.chef/",
      "sudo cp /etc/opscode/orgs/${var.chef_server_starter_pack_org}-validation.pem /tmp/chef-repo/.chef/",
      "cp ${var.chef_server_starter_pack_knife_rb_path} /tmp/chef-repo/.chef/",
      "sudo chown -R ${var.system_user_name}:${var.system_user_name} /tmp/chef-repo",
      "tar czf ${var.chef_server_starter_pack_location} -C /tmp/ chef-repo/"
    ]
  }
  depends_on = ["null_resource.chef_run"]
}

data "external" "chef_server_details" {
  program = ["bash", "${path.module}/files/data_source.sh"]
  depends_on = ["null_resource.starter_pack"]

  query = {
    ssh_user              = "${var.system_user_name}"
    ssh_key               = "${var.system_user_private_ssh_key}"
    ssh_pass              = "${var.system_user_pass}"
    chef_server_ip        = "${module.chef_server.public_ip[0]}"
    starter_pack_location = "${var.chef_server_starter_pack_location}"
    starter_pack_dest     = "${var.chef_server_starter_pack_dest}"
    chef_user             = "${var.chef_server_starter_pack_user}"
    chef_org              = "${var.chef_server_starter_pack_org}"
  }
}
