apt-get update
apt-get upgrade
apt-get -t wheezy-backports install libgnutls28-dev -y
apt-get install build-essential pkg-config gnutls-bin libwrap0-dev libpam0g-dev liblz4-dev libseccomp-dev libreadl
ine-dev libnl-route-3-dev -y
cd /opt
git clone git://git.infradead.org/ocserv.git 
cd ocser*
sed -i 's/#define MAX_CONFIG_ENTRIES 96//#define MAX_CONFIG_ENTRIES 250/g'  src/vpn.h
/configure 
make&&make install
mkdir /etc/ocserv
cp doc/sample.config /etc/ocserv/ocserv.conf
mkdir certificates&&cd certificates 

ip=$(ifconfig venet0:0|grep "inet addr:"|awk '{print $2}'|awk -F : '{print $2}')
cat << _EOF_ >ca.tmpl
cn = "${ip}"
organization = "Boybeta.com"
serial = 1
expiration_days = 3650
ca
signing_key
cert_signing_key
crl_signing_key
_EOF_
certtool --generate-privkey --outfile ca-key.pem
certtool --generate-self-signed --load-privkey ca-key.pem --template ca.tmpl --outfile ca-cert.pem

cat << _EOF_ >server.tmpl
cn = "${ip}"
organization = "Boybeta.com"
expiration_days = 3650
signing_key
encryption_key
tls_www_server
_EOF_

certtool --generate-privkey --outfile server-key.pem
certtool --generate-certificate --load-privkey server-key.pem --load-ca-certificate ca-cert.pem --load-ca-privkey ca-key.pem --template server.tmpl --outfile server-cert.pem

sudo cp ca-cert.pem /etc/ssl/private/my-ca-cert.pem
sudo cp server-cert.pem /etc/ssl/private/my-server-cert.pem
sudo cp server-key.pem /etc/ssl/private/my-server-key.pem


sed -i 's#auth = "plain[passwd=/etc/ocserv/ocpasswd]"#auth = "plain[passwd=/etc/ocserv/ocpasswd]#g ' /etc/ocserv/ocserv.conf
sed -i 's/#banner = "Welcome"/banner = "Welcome to athrun's home!"/g'  /etc/ocserv/ocserv.conf
sed -i 's/try-mtu-discovery = false/try-mtu-discovery = true/g'  /etc/ocserv/ocserv.conf
sed -i 's/try-mtu-discovery = false/try-mtu-discovery = true/g'  /etc/ocserv/ocserv.conf
sed -i 's/server-cert = /path/to/cert.pem/etc/ssl/private/my-server-cert.pem/g'  /etc/ocserv/ocserv.conf
server-cert = /path/to/cert.pem 


pwd
