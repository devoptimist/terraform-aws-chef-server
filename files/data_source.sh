#!/bin/bash
set -eu -o pipefail


eval "$(jq -r '@sh "export ssh_user=\(.ssh_user) ssh_key=\(.ssh_key) ssh_pass=\(.ssh_pass) chef_server_ip=\(.chef_server_ip) starter_pack_location=\(.starter_pack_location) starter_pack_dest=\(.starter_pack_dest) chef_user=\(.chef_user) chef_org=\(.chef_org)"')"

ssh-keyscan -H ${chef_server_ip} >> ~/.ssh/known_hosts 2>/dev/null

if [[ ! -z "${ssh_key}" ]]; then
  scp -i ${ssh_key} ${ssh_user}@${chef_server_ip}:/tmp/chef-repo/.chef/${chef_user}.pem /tmp/${chef_user}.pem &>/dev/null
  scp -i ${ssh_key} ${ssh_user}@${chef_server_ip}:/tmp/chef-repo/.chef/${chef_org}-validation.pem /tmp/${chef_org}-validation.pem &>/dev/null
  scp -i ${ssh_key} ${ssh_user}@${chef_server_ip}:${starter_pack_location} ${starter_pack_dest} 2>/dev/null
else 
  if ! hash sshpass; then
    echo "must install sshpass"
    exit 1
  else
    sshpass -p ${ssh_pass} scp ${ssh_user}@${chef_server_ip}:/tmp/chef-repo/.chef/${chef_user}.pem /tmp/${chef_user}.pem &>/dev/null
    sshpass -p ${ssh_pass} scp ${ssh_user}@${chef_server_ip}:/tmp/chef-repo/.chef/${chef_org}-validation.pem /tmp/${chef_org}-validation.pem &>/dev/null
    sshpass -p ${ssh_pass} scp ${ssh_user}@${chef_server_ip}:${starter_pack_location} ${starter_pack_dest} &>/dev/null
  fi
fi

VAR1=$(cat <<EOF
{
  "starter_pack": "/tmp/chef-starter-pack.tar.gz",
  "validation_pem": "$(sed ':a;N;$!ba;s/\n/\\n/g' /tmp/${chef_org}-validation.pem)",
  "validation_client_name": "${chef_org}-validation",
  "client_pem": "$(sed ':a;N;$!ba;s/\n/\\n/g' /tmp/${chef_user}.pem)",
  "chef_server_url": "https://${chef_server_ip}/organisations/${chef_org}",
  "node_name": "${chef_user}"
}
EOF
)
echo "${VAR1}" | jq '.'
