#WARNING: installation will fail in case of air-gapped or proxied systems.

Vagrant.configure("2") do |config|
  config.vm.network "forwarded_port", guest: 31230, host: 31230, protocol: "tcp"
  config.vm.network "forwarded_port", guest: 31234, host: 31234, protocol: "tcp"
  config.vm.network "forwarded_port", guest: 8080, host: 8080, protocol: "tcp"
  config.vm.define "master" do |master|
    master.vm.box = "ubuntu/jammy64"        ## official canonical image 22.04 lts
    master.vm.hostname = "master"
    master.vm.provider "virtualbox" do |v|
      v.name = "master"
      v.memory = 8192
      v.cpus = 2
    end
  config.vm.provision :shell, path: "bootstrap.sh"
  end

 #todo: multiple node configuration 
 # config.vm.define "worker" do |worker|
 #   worker.vm.box = "ubuntu/jammy64"        ## official canonical image 22.04 lts
 #   worker.vm.network "private_network", ip: "192.168.56.3", hostname: true
 #   worker.vm.hostname = "worker"
 #   worker.vm.provider "virtualbox" do |v|
 #     v.name = "worker"
 #     v.memory = 2024
 #     v.cpus = 2
 #   end
 # config.vm.provision :shell, path: "bootstrap.sh"
 # end

end