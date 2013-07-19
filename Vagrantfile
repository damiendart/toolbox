# Damien's general purpose Vagrantfile.
#
# This file was written by Damien Dart, <damiendart@pobox.com>. This is free
# and unencumbered software released into the public domain. For more
# information, please refer to the accompanying "UNLICENCE" file.

Vagrant.configure("2") do |config|
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"
  puts "# Updating package lists..." 
  config.vm.provision :shell, :inline => "sudo apt-get -qqy update"
  ["build-essential", "git", "vim", "ruby", "screen"].each do |package|
    puts "# Installing the \"#{package}\" package..."
    config.vm.provision :shell, :inline => "sudo apt-get install -qqy #{package}"
  end
end
