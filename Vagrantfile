# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'json'

unless Vagrant.has_plugin?("vagrant-disksize")
	raise 'vagrant-disksize is not installed!'
end

file_secrets = File.read('./secrets/redhat_secrets')
secrets = JSON.parse(file_secrets)

file_config = File.read('./config/variables')
conf = JSON.parse(file_config)

Vagrant.configure("2") do |config|

  config.vm.box = "#{conf['BOX']}"
  config.disksize.size = "#{conf['HD_SIZE']}"
  config.vm.box_check_update = false
  config.ssh.pty = true
  config.ssh.insert_key = false
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.provider "virtualbox" do |v, override|
    v.gui = false
    v.memory = 8192
    v.cpus   = 2
    v.customize ["modifyvm", :id, "--ioapic", "on"]
    v.customize ["modifyvm", :id, "--nictype1", "virtio" ]
    v.customize ["modifyvm", :id, "--nictype2", "virtio" ]
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  config.vm.network "forwarded_port", guest: 8443, host: 8443
  config.vm.network "forwarded_port", guest: 80, host: 8180
  config.vm.network "forwarded_port", guest: 443, host: 8043
  config.vm.hostname = "repo.vagrant.local"
  config.vm.network "private_network", ip: "192.168.200.5", virtualbox__intnet: "INTERNAL NET"

  config.vm.provision "SUBSCRIBE", upload_path: "/home/vagrant/vagrant-shell", type: "shell", path: './scripts/subscribe.sh', args: "#{secrets['USERNAME']} #{secrets['PASSWORD']} #{secrets['POOL']} #{conf['OCP_VERSION']} #{conf['ANSIBLE_VERSION']}"
  config.vm.provision "NGINX", upload_path: "/home/vagrant/vagrant-shell", type: "shell", path: './scripts/nginx.sh'
  config.vm.provision "UNSUBSCRIBE", upload_path: "/home/vagrant/vagrant-shell", type: "shell", path: './scripts/unsubscribe.sh'
end
