output "chef_server_ip" {
  value = module.chef_server.public_ip
}

output "chef_server_user" {
  value = var.system_user_name
}

output "chef_server_pass" {
  value = var.system_user_pass
}

output "starter_pack_location" {
  value = data.external.chef_server_details.result["starter_pack"]
}

output "validation_pem" {
  value = data.external.chef_server_details.result["validation_pem"]
}

output "client_pem" {
  value = data.external.chef_server_details.result["client_pem"]
}

output "chef_server_url" {
  value = data.external.chef_server_details.result["chef_server_url"]
}

output "node_name" {
  value = data.external.chef_server_details.result["node_name"]
}
