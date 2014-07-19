# Main vagrant conf file...
Vagrant::Config.run do |config|
  config.vm.box       = 'precise64'
  config.vm.box_url   = 'http://files.vagrantup.com/precise64.box'
  config.vm.forward_port 80, 8682
  config.vm.share_folder "shared_folder", "/home/vagrant/shared_folder", "shared_folder"

  config.vm.provision :puppet,
    :manifests_path => 'puppet/manifests',
    :module_path    => 'puppet/modules'
end
