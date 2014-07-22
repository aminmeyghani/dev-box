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