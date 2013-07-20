# Damien's general purpose Vagrantfile.
#
# This file was written by Damien Dart, <damiendart@pobox.com>. This is free
# and unencumbered software released into the public domain. For more
# information, please refer to the accompanying "UNLICENCE" file.

Vagrant.configure("2") do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.provision :shell, :inline => <<SCRIPT
set -ex
apt-get update -y
apt-get install -y build-essential python ruby screen vim
# The version of Git available from "apt-get" is too old to work with GitHub.
apt-get -y build-dep git
wget --progress=dot https://github.com/git/git/archive/v1.8.3.3.tar.gz
tar -zxf v1.8.3.3.tar.gz
cd git-1.8.3.3
make prefix=/usr/local all install
rm -rf ../git-1.8.3.3 ../v1.8.3.3.tar.gz
SCRIPT
end
