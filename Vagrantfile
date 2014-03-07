# Damien Dart's general purpose Vagrantfile.
#
# This file was written by Damien Dart, <damiendart@pobox.com>. This is
# free and unencumbered software released into the public domain. For
# more information, please refer to the accompanying "UNLICENCE" file.

Vagrant.configure("2") do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.provision :shell, :inline => <<SCRIPT
GIT_VERSION="1.9.0"
trap "rm -fr git-$GIT_VERSION" EXIT
set -ex
echo "Europe/London" > /etc/timezone
dpkg-reconfigure --frontend noninteractive tzdata
# Prevent time on virtual machine from becoming severely out of sync.
VBoxService --timesync-set-threshold 1000
apt-get update -y
apt-get install -y apache2 build-essential python screen vim
# The version of Git available from "apt-get" is too old to work with GitHub.
apt-get -y build-dep git
wget -O - https://github.com/git/git/archive/v$GIT_VERSION.tar.gz | tar -zx
(cd git-$GIT_VERSION && make prefix=/usr/local all install)
echo "*.pyc\n*.swp" | sudo -u vagrant tee -a /home/vagrant/.gitignore
sudo -iu vagrant git config --global core.excludesfile "/home/vagrant/.gitignore"
sudo -iu vagrant git config --global user.email "damiendart@pobox.com"
sudo -iu vagrant git config --global user.name "Damien Dart"
# Ruby version managers are the way to go.
apt-get -y build-dep ruby
sudo -iu vagrant git clone https://github.com/sstephenson/rbenv.git /home/vagrant/.rbenv
sudo -iu vagrant git clone https://github.com/sstephenson/ruby-build.git /home/vagrant/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' | sudo -u vagrant tee -a /home/vagrant/.profile
echo 'eval "$(rbenv init -)"' | sudo -u vagrant tee -a /home/vagrant/.profile
sudo -iu vagrant rbenv install 2.0.0-p353
sudo -iu vagrant rbenv rehash
sudo -iu vagrant rbenv global 2.0.0-p353
sudo -iu vagrant gem update --system
sudo -iu vagrant gem install bundler --no-document
SCRIPT
end
