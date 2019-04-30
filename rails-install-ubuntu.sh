#!/bin/bash

if
  [[ "${USER:-}" == "root" ]]
then
  echo "This script works only with normal user, it wont work with root, please log in as normal user and try again." >&2
  exit 1
fi

set -e
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

echo "Updates packages. Asks for your password."
sudo apt-get update -y

echo "Installs packages. Give your password when asked."
sudo apt-get --ignore-missing install build-essential git-core curl openssl libgdbm-dev libssl-dev libcurl4-openssl-dev zlib1g zlib1g-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libffi-dev software-properties-common libgdm-dev libncurses5-dev automake autoconf libtool bison libpq-dev pgadmin3 libc6-dev nodejs yarn -y

echo "Installs ImageMagick for image processing"
sudo apt-get install imagemagick --fix-missing -y

echo "Installs RVM (Ruby Version Manager) for handling Ruby installation"
# Retrieve the GPG key.
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm

echo "Installs Ruby"
rvm install 2.6.1
rvm use 2.6.1 --default
 

echo "gem: --no-ri --no-rdoc" > ~/.gemrc
echo "Installing bundler and rails"
gem install bundler
gem install rails -v 5.2.3

echo -e "\n- - - - - -\n"
echo -e "Now we are going to print some information to check that everything is done:\n"


echo -n "Should be sqlite 3.8.1 or higher: sqlite "
sqlite3 --version
echo -n "Should be rvm 1.26.11 or higher:         "
rvm --version | sed '/^.*$/N;s/\n//g' | cut -c 1-11
echo -n "Should be ruby 2.6.1:                "
ruby -v | cut -d " " -f 2
echo -n "Should be Rails 5.2.3 or higher:         "
rails -v
echo -e "\n- - - - - -\n"

echo "If the versions match, everything is installed correctly. If the versions
don't match or errors are shown, something went wrong with the automated process
and we will help you do the installation the manual way at the event.

Congrats!

Make sure that all works well by running the application generator command:
    $ rails new railsgirls

If you encounter the message:
    The program 'rails' is currently not installed.

It is just a hiccup with the shell, solutions:                                   
    $ source ~/.rvm/scripts/rvm
    Allow login shell, example http://rvm.io/integration/gnome-terminal/"
