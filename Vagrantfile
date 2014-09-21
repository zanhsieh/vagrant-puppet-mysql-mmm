## RESOURCES
# http://stackoverflow.com/questions/2366018/how-to-re-sync-the-mysql-db-if-master-and-slave-have-different-database-incase-o


VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define "m1" do |m1|
    m1.vm.box = "ubuntu/trusty64"
    m1.vm.hostname = "m1"
    m1.vm.network :private_network, :ip => "192.168.30.101"
    m1.vm.provision :puppet do |puppet|
      puppet.manifest_file = "m1.pp"
      puppet.module_path = "puppet-modules"
      puppet.options = "--pluginsync --verbose"
    end
  end
  config.vm.define "m2" do |m2|
    m2.vm.box = "ubuntu/trusty64"
    m2.vm.hostname = "m2"
    m2.vm.network :private_network, :ip => "192.168.30.102"
    m2.vm.provision :puppet do |puppet|
      puppet.manifest_file = "m2.pp"
      puppet.module_path = "puppet-modules"
      puppet.options = "--pluginsync --verbose"
    end
  end

=begin
  config.vm.define "m3" do |m3|
    m3.vm.box = "ubuntu/trusty64"
    m3.vm.hostname = "m3"
    m3.vm.network :private_network, :ip => "192.168.30.103"
    m3.vm.provision :puppet do |puppet|
      puppet.manifest_file = "m3.pp"
      puppet.module_path = "puppet-modules"
      puppet.options = "--pluginsync --verbose"
    end
  end
=end
end
