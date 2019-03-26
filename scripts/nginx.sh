#!/bin/bash

OCP_RELEASE=$1
ANSIBLE_VERSION=$2

yum -y install yum-utils createrepo
mkdir -p /var/www/html/repos
mkdir -p /var/cache/nginx

for repo in \
	rhel-7-server-rpms \
	rhel-7-server-extras-rpms \
	rhel-7-server-ansible-${ANSIBLE_VERSION}-rpms \
	rhel-7-server-ose-${OCP_RELEASE}-rpms
	do
		reposync --gpgcheck -lm --repoid=${repo} --download_path=/var/www/html/repos
		createrepo -v /var/www/html/repos/${repo} -o /var/www/html/repos/${repo} 
	done

yum install -y nginx
rm -rf /etc/yum.repos.d/nginx.repo
rm -rf /etc/nginx/conf.d/*

cat > /etc/yum.repos.d/nginx.repo <<EOF
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/rhel/7/x86_64/
gpgcheck=0
enabled=1
EOF

cat > '/etc/nginx/conf.d/default.conf' <<EOF
server {
	listen 8080;
	server_name localhost;
	root /var/www/html/repos;

	location / {
		autoindex on;
	}
}
EOF

cat > '/etc/nginx/nginx.conf' <<EOF
events {
	worker_connections 1024;
}
http {
	include /etc/nginx/conf.d/*.conf;
}
EOF

restorecon -Rv /var/www/html/
systemctl restart nginx