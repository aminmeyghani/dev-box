#! /bin/bash
# Installing GCC and G++ 4.8
# More information:
# http://charette.no-ip.com:81/programming/2011-12-24_GCCv47/
# ================
# update
sudo apt-get update
sudo apt-get install build-essential git-core python-software-properties -y
# Add Repo
sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
sudo apt-get update
sudo apt-get install gcc-4.8 g++-4.8 -y
# Update sym links
sudo rm /usr/bin/gcc
sudo rm /usr/bin/g++
sudo ln -s /usr/bin/gcc-4.8 /usr/bin/gcc
sudo ln -s /usr/bin/g++-4.8 /usr/bin/g++

# Installing Node
# ================
NODEVERSION=0.10.28
NODEARCHVALUE=64
# read -p " which version of Node do you need to install: enter 0.10.24 or 0.10.28: " NODEVERSION
# read -p " Are you using a 32-bit or 64-bit operating system ? Enter 64 or 32: " NODEARCHVALUE
# do if doesnt exist
if [ ! -f /usr/local/bin/node ]
	then
	if [[ $NODEARCHVALUE = 32 ]]
		then
		printf "user put in 32 \n"
		NODEARCHVALUE=86
		URL=http://nodejs.org/dist/v${NODEVERSION}/node-v${NODEVERSION}-linux-x${NODEARCHVALUE}.tar.gz

	elif [[ $NODEARCHVALUE = 64 ]]
		then
		printf "user put in 64 \n"
		NODEARCHVALUE=64
		URL=http://nodejs.org/dist/v${NODEVERSION}/node-v${NODEVERSION}-linux-x${NODEARCHVALUE}.tar.gz

	else
		printf "invalid input expted either 32 or 64 as input, quitting ... \n"

		exit
	fi

	# setting up the folders and the the symbolic links
	printf $URL"\n"
	ME=$(whoami) ; sudo chown -R $ME /usr/local && cd /usr/local/bin #adding yourself to the group to access /usr/local/bin
	mkdir _node && cd $_ &&	wget $URL -O - | tar zxf - --strip-components=1 # downloads and unzips the content to _node
	cp -r ./lib/node_modules/ /usr/local/lib/ # copy the node modules folder to the /lib/ folder
	cp -r ./include/node /usr/local/include/ # copy the /include/node folder to /usr/local/include folder
	mkdir /usr/local/man/man1 # create the man folder
	cp ./share/man/man1/node.1 /usr/local/man/man1/ # copy the man file
	cp bin/node /usr/local/bin/ # copy node to the bin folder
	ln -s "/usr/local/lib/node_modules/npm/bin/npm-cli.js" ../npm ## making the symbolic link to npm

	# clean up _node
	sudo rm -rf /usr/local/bin/_node
else
	echo "node is already installed" 
	exit 0
fi


# print the version of node and npm
# node -v
# npm -v


# Installing Rails
# ================
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

# Installing LAMP
# Doesn't install MYSQL .... (yet)
# ================
# install php and apache
if [ ! -d /etc/apache2 ]
	then
	echo "######INSTALLING PHP and apache and all the requriemtns########"
	sudo apt-get install apache2 libapache2-mod-php5 -y
	sudo apt-get install php5 php-pear php5-mysql php5-suhosin -y
	echo "###### installing the rest ... #########"
	sudo apt-get install php5-mysql php5-gd -y
else 
	echo "lamp is already installed ..." 
fi