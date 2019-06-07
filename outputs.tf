output "chef_server_ip" {
  value = module.chef_server.public_ip
}

output "chef_server_user" {
  value = var.system_user_name
}

output "chef_server_pass" {
  value = var.system_user_pass
}
