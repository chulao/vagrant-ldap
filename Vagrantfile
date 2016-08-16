# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

NAME="ldap"
OS=`uname -s`.strip


# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.
  
  config.vm.define NAME do |t|
  end

  config.vm.box = "debian/jessie64"

  config.vm.hostname = "#{NAME}.vagrant.dev"

  # Activate landrush plugin
  config.landrush.enable
  config.landrush.tld = "vagrant.dev"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777","fmode=777"]

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "512"]
    vb.customize ["modifyvm", :id, "--name"  , "vagrant-#{NAME}"]
    vb.customize ["modifyvm", :id, "--cpus"  , 1]
  end

  # If choose 'debian/jessie64' box, please install the provisioner as informed on https://wiki.debian.org/Teams/Cloud/VagrantBaseBoxes#Provisioners
  config.vm.provision "shell", inline: "apt-get install --yes puppet"

  # If you would like using ldap commands inside machine, please install 'ldap-utils'
  # config.vm.provision "shell", inline: "apt-get install --yes ldap-utils"

  config.vm.provision :puppet do |puppet|
    puppet.hiera_config_path = "puppet/hiera.yaml"
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.manifest_file  = "init.pp"
    # puppet.options = "--verbose --debug"
  end
end
