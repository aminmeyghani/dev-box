#! /bin/bash
# Installing Rails
#---------------------
# Installs rbenv
# Installs Ruby 2.0.1
# Installs Rails without the documentations.
# More Details on the rbenv instlaler:
# https://github.com/fesplugas/rbenv-installer
# ---------------------
# update repos.
sudo apt-get update

# install some basic packages
sudo apt-get install curl build-essential git-core sqlite3 libsqlite3-dev -y

# install rbenv only if it is not already installed.
if [ ! -d ${HOME}/.rbenv ]
	then
		sudo curl https://raw.githubusercontent.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash
else
	echo "rbenv is already installed"
fi
# Adding rbenv to path by adding it to the bash_profile.
# check if it is already in the file, add to the file only if it is not there already.
# TODO: maybe for the settings I should move the sh to the /etc/profiles.d .... ?
# this folder is treated as /vagrant ... so, maybe if I do cp /vagrant/myfile ~/location ... ?
if grep -q "RBENV_ROOT" "${HOME}/.bash_profile"
	then
	echo "rbenv settings already exists." 
else
	SETTINGS="
	export RBENV_ROOT=\"\${HOME}/.rbenv\" \n
	if [ -d \"\${RBENV_ROOT}\" ]; then \n
		\t export PATH=\"\${RBENV_ROOT}/bin:\${PATH}\" \n
		\t eval \"\$(rbenv init -)\" \n
	fi
	"
	# add to the bash profile if not already added.
	echo -e $SETTINGS >> ${HOME}/.bash_profile 
	echo -e "rbenv settings added to path"
fi

# restart the bash
source ~/.bash_profile

# installing ruby 2.0.1 only if it is not already installed.
if [ -d ${HOME}/.rbenv/versions/2.1.0 ]; then echo "Ruby 2.0.1 is already installed : $(rbenv global)" ; else rbenv install 2.1.0 ; fi

# set the gloal ruby to ruby 2.0.1
rbenv global 2.1.0

# install rails only if it is not installed alreayd.
if [ ! $(which rails)  ]; then gem install rails --no-rdoc --no-ri  ; else echo "rails is already installed: $(rails -v)"; fi
