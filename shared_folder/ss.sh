if [ ! -f /usr/local/bin/node ]
	then
	echo "installing grunt ..." 
	#/usr/local/bin/npm install -g grunt-cli
else
	echo "grunt was already installed"  
	exit 0
fi
