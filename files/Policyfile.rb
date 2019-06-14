name 'chef_server_wrapper'
default_source :supermarket

run_list 'chef_server_wrapper::default'
named_run_list :chef_server, 'chef_server_wrapper::default'

cookbook 'chef_server_wrapper', github: 'devoptimist/chef_server_wrapper', tag: 'v0.1.9'
cookbook 'chef-ingredient'    , github: 'chef-cookbooks/chef-ingredient', tag: 'v3.1.1'
