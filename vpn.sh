apt-get update
apt-get upgrade
apt-get -t wheezy-backports install libgnutls28-dev -y
apt-get install build-essential pkg-config gnutls-bin libwrap0-dev libpam0g-dev liblz4-dev libseccomp-dev libreadl
ine-dev libnl-route-3-dev -y
cd /opt
git clone git://git.infradead.org/ocserv.git 
cd ocser*
sed -i s/#define MAX_CONFIG_ENTRIES 96//#define MAX_CONFIG_ENTRIES 250/g 

pwd
