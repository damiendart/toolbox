# Damien Dart's general purpose Vagrantfile.
#
# This file was written by Damien Dart, <damiendart@pobox.com>. This is
# free and unencumbered software released into the public domain. For
# more information, please refer to the accompanying "UNLICENCE" file.

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.provision :shell, :inline => <<SCRIPT
set -ex
echo "Europe/London" > /etc/timezone
dpkg-reconfigure --frontend noninteractive tzdata
# Prevent time on virtual machine from becoming severely out of sync.
VBoxService --timesync-set-threshold 1000
apt-get update -y
# CPAN regularly craps out with OOM errors, while "cpanminus" doesn't.
apt-get install -y apache2 build-essential cpanminus git python ruby-full screen vim
echo ".bundle\n*.pyc\n*.swp" | sudo -u vagrant tee -a /home/vagrant/.gitignore
sudo -iu vagrant git config --global core.excludesfile "/home/vagrant/.gitignore"
sudo -iu vagrant git config --global user.email "damiendart@pobox.com"
sudo -iu vagrant git config --global user.name "Damien Dart"
SCRIPT
end
