#! /bin/bash
# install php and apache
sudo apt-get update
sudo apt-get install build-essential git-core python-software-properties -y
if [ ! -d /etc/apache2 ]
	then
		echo "######INSTALLING PHP and apache and all the requriemtns########"
		sudo apt-get install apache2 libapache2-mod-php5 -y
		sudo apt-get install php5 php-pear php5-mysql php5-suhosin -y
		echo "###### installing the rest ... #########"
		sudo apt-get install php5-mysql php5-gd -y
else 
	echo "lamp is already installed ..." >> /home/vagrant/puppetlog.txt
fi