#! /bin/bash
# install php and apache
echo "######INSTALLING PHP and apache and all the requriemtns########"
sudo apt-get install apache2 libapache2-mod-php5 -y
sudo apt-get install php5 php-pear php5-mysql php5-suhosin -y
echo "###### installing the rest ... #########"
sudo apt-get install php5-mysql php5-gd -y
