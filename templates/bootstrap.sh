#!/bin/bash -x
exec > /tmp/part-001.log 2>&1

%{ if create_system_user }
useradd ${system_user_name}
if sed 's/"//g' /etc/os-release |grep -e '^NAME=CentOS' -e '^NAME=Fedora' -e '^NAME=Red'
then
  usermod -a -G wheel ${system_user_name}
  yum install -y git
elif sed 's/"//g' /etc/os-release |grep -e '^NAME=Mint' -e '^NAME=Ubuntu' -e '^NAME=Debian'
then
  usermod -a -G sudo ${system_user_name}
  apt-get install -y git
fi

echo "${system_user_pass}" | passwd --stdin ${system_user_name}

printf >"/etc/sudoers.d/${system_user_name}" '%s    ALL= NOPASSWD: ALL\n' "${system_user_name}"

sed -i  's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

systemctl restart sshd


%{ if system_user_public_ssh_key != "" }
mkdir /home/${system_user_name}/.ssh
cat << EOF >>/home/${system_user_name}/.ssh/authorized_keys
${system_user_public_ssh_key}
EOF
chmod 600 /home/${system_user_name}/.ssh/authorized_keys
%{ endif }

%{ endif }
