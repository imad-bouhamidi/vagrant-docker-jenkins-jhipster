# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # name of the box
	config.vm.box = "ubuntu/trusty64"
  # setting hostname
	config.vm.hostname = "OmniDevOps"
  # set up public_network
	config.vm.network "public_network"
	
  # better to match jhipster docker container port  
    config.vm.network "forwarded_port", guest: 8080, host: 8080
    config.vm.network "forwarded_port", guest: 9000, host: 9000
    config.vm.network "forwarded_port", guest: 35729, host: 35729
    config.vm.network "forwarded_port", guest: 4022, host: 4022
	
  # mapping the shared folder between the guest machine and vagrant VM
	config.vm.synced_folder "./jhipster", "/home/vagrant/jhipster", :create => true
	config.vm.synced_folder "./scripts", "/home/scripts", :create => true
	config.vm.synced_folder "./jenkins/home/", "/var/lib/jenkins", :create => true
	
	
  # running script shell
	config.vm.provision :shell, :path => "scripts/Bootstrap.sh"

  # Pull docker image from "jdubois/jhipster-docker"
	config.vm.provision "docker", images: ["jdubois/jhipster-docker"]
	
  # Run docker
	config.vm.provision "docker" do |d|
	  # with argument: for mapping docker folder "/jhipster" with vagrant shared folder "/home/vagrant/jhipster"
      d.run "jdubois/jhipster-docker", args: "-v /home/vagrant/jhipster:/jhipster -p 8080:8080 -p 9000:9000 -p 35729:35729 -p 4022:22"
	end
	
	# running script shell
	config.vm.provision :shell, :path => "scripts/jhipster.sh"
	
  # running script shell
	config.vm.provision :shell, :path => "scripts/jenkins_installation.sh"

  # VirtualBox Specific Customization
    config.vm.provider "virtualbox" do |vb|
		# Use VBoxManage to customize the VM. For example to change memory:
		vb.customize ["modifyvm", :id, "--memory", "3072"]
    end

end
