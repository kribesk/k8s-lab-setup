echo ">>>>>>>>>> INSTALLING PACKAGES..."

echo "IPv6 off..."
sysctl net.ipv6.conf.all.disable_ipv6=1
sysctl net.ipv6.conf.default.disable_ipv6=1
sysctl net.ipv6.conf.lo.disable_ipv6=1

apt-get update
apt-get install -y docker.io git

echo ">>>>>>>>>> GETTING MATCHBOX & CORE OS..."

cd /vagrant
if [ ! -d matchbox ]; then
  git clone https://github.com/coreos/matchbox.git
fi
cd matchbox
if [ ! -d examples/assets/coreos ]; then
  ./scripts/get-coreos stable 1235.9.0 ./examples/assets 2> /dev/null
fi

echo ">>>>>>>>>> GETTING CONTAINERS..."

docker pull quay.io/coreos/matchbox:latest
docker pull quay.io/coreos/dnsmasq:latest 

systemctl stop systemd-resolved.service

echo ">>>>>>>>>>> SETTING STATIC IP..."

cat << EOF > /etc/network/interfaces

# Static ip on bridge interface
auto enp0s8
iface enp0s8 inet static
        address 172.18.0.2
        netmask 255.255.255.0
EOF
ifdown enp0s8 || ifup enp0s8
