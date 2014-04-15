# Damien Dart's general purpose Vagrantfile.
#
# This file was written by Damien Dart, <damiendart@pobox.com>. This is
# free and unencumbered software released into the public domain. For
# more information, please refer to the accompanying "UNLICENCE" file.

Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/precise64"
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.provision :shell, :inline => <<SCRIPT
HAXE_VERSION="3.1.3"
NEKO_VERSION="v2-0"
RUBY_VERSION="2.0.0-p353"
GIT_VERSION="1.9.0"
trap "rm -fr git-$GIT_VERSION haxe neko" EXIT
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
echo ".bundle\n*.pyc\n*.swp" | sudo -u vagrant tee -a /home/vagrant/.gitignore
sudo -iu vagrant git config --global core.excludesfile "/home/vagrant/.gitignore"
sudo -iu vagrant git config --global user.email "damiendart@pobox.com"
sudo -iu vagrant git config --global user.name "Damien Dart"
# Ruby version managers are the way to go.
apt-get -y build-dep ruby
sudo -iu vagrant git clone https://github.com/sstephenson/rbenv.git /home/vagrant/.rbenv
sudo -iu vagrant git clone https://github.com/sstephenson/ruby-build.git /home/vagrant/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' | sudo -u vagrant tee -a /home/vagrant/.profile
echo 'eval "$(rbenv init -)"' | sudo -u vagrant tee -a /home/vagrant/.profile
sudo -iu vagrant rbenv install $RUBY_VERSION
sudo -iu vagrant rbenv rehash
sudo -iu vagrant rbenv global $RUBY_VERSION
sudo -iu vagrant gem update --system
sudo -iu vagrant gem install bundler --no-document
# The version of Haxe/Lime/OpenFL from "apt-get" is way out of date.
apt-get -y build-dep haxe neko
git clone --recursive https://github.com/HaxeFoundation/haxe.git haxe
(cd haxe && git checkout $HAXE_VERSION && make prefix=/usr/local all install)
git clone https://github.com/HaxeFoundation/neko
(cd neko && git checkout $NEKO_VERSION && echo "s" | make prefix=/usr/local all install)
apt-get install -y libgl1-mesa-dev
echo | haxelib setup && haxelib install lime && echo "y" | haxelib run lime setup && lime install openfl
SCRIPT
end
