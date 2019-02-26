#cloud-config
apt_upgrade: true
apt_update: true
locale: en_US.UTF-8
packages:
 - git
 - vim
 - zip
 - unzip
runcmd:
 - sudo echo ${hostname} > /etc/hostname
 - sudo hostnamectl set-hostname ${hostname}
 - sudo apt-get update
 - sudo apt-get -y update
 - sudo apt-get install -y python3-pip
