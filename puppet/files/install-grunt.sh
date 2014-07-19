#! /bin/bash
if [ ! -f /usr/local/bin/grunt ]
	then
	echo "installing grunt ..." >> /home/vagrant/puppetlog.txt
	/usr/local/bin/npm install -g grunt-cli
else
	echo "grunt was already installed"  >> /home/vagrant/puppetlog.txt
	exit 0
fi
