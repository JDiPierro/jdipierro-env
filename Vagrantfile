# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.synced_folder ".", "/jdipierro_env"

  # config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "private_network", ip: "192.168.2.2"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
    vb.name = "dev"
  end
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update
    sudo apt-get install -y build-essential wget git vim
    sudo apt-get install -y bzip2 unzip p7zip-full
    bash /jdipierro_env/setup_env.sh
  SHELL
end
