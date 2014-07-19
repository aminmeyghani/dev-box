# -*- mode: ruby -*-
# vi: set ft=ruby :

# Main vagrant conf file...
#  V1
# Vagrant::Config.run do |config|
#   config.vm.box       = 'precise64'
#   config.vm.box_url   = 'http://files.vagrantup.com/precise64.box'
#   config.vm.forward_port 80, 8682
  

#   config.vm.provision :puppet,
#     :manifests_path => 'puppet/manifests',
#     :module_path    => 'puppet/modules'
# end


# V2
Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "precise64"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network :forwarded_port, guest: 80, host: 8780

  # shared folder
   config.vm.synced_folder "shared_folder", "/home/vagrant/shared_folder"

  # puppet
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = 'puppet/manifests'
    puppet.module_path    = 'puppet/modules'
  end
end
