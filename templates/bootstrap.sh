#!/bin/bash
rpm -Uhv https://packages.chef.io/files/stable/chef-server/${chef_server_version}/el/7/chef-server-core-${chef_server_version}-1.el7.x86_64.rpm
chef-server-ctl reconfigure

chef-server-ctl org-create ${chef_org} ${chef_org} -f ${chef_org_pem}/${chef_org}-validator.pem
chef-server-ctl user-create ${chef_user} This User ${chef_user}@example.com ${chef_pass} -f ${chef_user_pem}/${chef_user}.pem
chef-server-ctl org-user-add ${chef_org} ${chef_user} --admin
