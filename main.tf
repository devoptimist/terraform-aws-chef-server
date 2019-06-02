data "template_file" "bootstrap" {
  template = "${file("${path.module}/templates/bootstrap.sh")}"

  vars {
    chef_user           = "${var.chef_user}",
    chef_pass           = "${var.chef_pass}",
    chef_org            = "${var.chef_org}",
    chef_server_version = "${var.chef_server_version}",
    chef_org_pem        = "${var.chef_org_pem}",
    chef_user_pem       = "${var.chef_user_pem}"
  }
}

module "chef_server" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "1.21.0"
  name                        = "${var.name}-chef-server"
  instance_count              = "${var.instance_count}"
  ami                         = "${var.ami}"
  instance_type               = "${var.instance_type}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  key_name                    = "${var.key_name}"
  monitoring                  = true
  vpc_security_group_ids      = "${var.vpc_security_group_ids}"
  subnet_ids                  = "${var.subnet_ids}"
  root_block_device = [{
    volume_type = "gp2"
    volume_size = "${var.root_disk_size}"
  }]
  tags                        = "${var.tags}"
  user_data                   = "${data.template_file.bootstrap.rendered}"
}
