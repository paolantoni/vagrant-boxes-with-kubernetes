#WARNING: installation will fail in case of air-gapped or proxied systems.

Vagrant.configure("2") do |config|
  config.vm.define "master" do |master|
    master.vm.box = "ubuntu/jammy64"        ## official canonical image 22.04 lts
    master.vm.network "private_network", ip: "192.168.56.2", hostname: true
    master.vm.hostname = "master"
    master.vm.provider "virtualbox" do |v|
      v.name = "master"
      v.memory = 2048
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