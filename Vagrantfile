Vagrant.configure(2) do |config| 

#default docker installation config
    config.ssh.insert_key = false

    $puppetrpm = <<PUPPETRPM
    sudo dnf install -y https://yum.puppet.com/puppet7/puppet-release-el-8.noarch.rpm
    sudo dnf install -y puppet
PUPPETRPM

$modulesweb = <<MODULESWEB
puppet module install puppetlabs-firewall
puppet module install puppet-selinux
sudo cp -vR ~/.puppetlabs/etc/code/modules/ /etc/puppetlabs/code
MODULESWEB

$modulesdb = <<MODULESDB
puppet module install puppetlabs/mysql
puppet module install puppetlabs-firewall
sudo cp -vR ~/.puppetlabs/etc/code/modules/ /etc/puppetlabs/code
MODULESDB

    config.vm.define "docker" do |docker|
        docker.vm.box = "shekeriev/centos-stream-8"
        docker.vm.hostname = "docker.do2.lab"
        docker.vm.network "private_network", ip: "192.168.99.100"

        docker.vm.provision "shell", inline: <<EOS
echo "* Add EPEL repository ..."
dnf install -y epel-release

echo "* Install Python3 ..."
dnf install -y python3

echo "* Install Python docker module ..."
pip3 install docker

echo "* Install terraform"
wget https://releases.hashicorp.com/terraform/1.2.1/terraform_1.2.1_linux_amd64.zip
unzip terraform_1.2.1_linux_amd64
mv terraform /usr/local/bin

EOS
#default ansible config
        docker.vm.provision "ansible_local" do |ansible|
            ansible.become = true
            ansible.install_mode = :default
            ansible.playbook = "playbook.yml"
            ansible.galaxy_role_file = "requirements.yml"
            ansible.galaxy_roles_path = "/etc/ansible/roles"
            ansible.galaxy_command = "sudo ansible-galaxy install --role-file=%{role_file} --roles-path=%{roles_path} --force"
        end
    end

    config.vm.define "web" do |web|
        web.vm.box = "shekeriev/centos-stream-8"
        web.vm.hostname = "web.do2.lab"
        web.vm.network "private_network", ip: "192.168.99.101"
        web.vm.provision "shell", inline: $puppetrpm, privileged: false
        web.vm.provision "shell", inline: $modulesweb, privileged: false

        web.vm.provision "puppet" do |puppet|
            puppet.manifests_path = "manifests"
            puppet.manifest_file = "web.pp"
            puppet.options = "--verbose --debug"
        end
    end

config.vm.define "db" do |db|
    db.vm.box = "shekeriev/centos-stream-8"
    db.vm.hostname = "db.do2.lab"
    db.vm.network "private_network", ip: "192.168.99.102"
    db.vm.provision "shell", inline: $puppetrpm, privileged: false
    db.vm.provision "shell", inline: $modulesdb, privileged: false
 
    db.vm.provision "puppet" do |puppet|
        puppet.manifests_path = "manifests"
        puppet.manifest_file = "db.pp"
        puppet.options = "--verbose --debug"
    end
end
end
