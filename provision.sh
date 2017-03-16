echo ">>>>>>>>>> INSTALLING PACKAGES..."

echo "IPv6 off..."
sysctl net.ipv6.conf.all.disable_ipv6=1
sysctl net.ipv6.conf.default.disable_ipv6=1
sysctl net.ipv6.conf.lo.disable_ipv6=1

apt-get update
apt-get install -y docker.io git

echo ">>>>>>>>>> GETTING MATCHBOX & CORE OS..."

cd /vagrant
git clone https://github.com/coreos/matchbox.git
cd matchbox
./scripts/get-coreos stable 1235.9.0 ./examples/assets 2> /dev/null

echo ">>>>>>>>>> GETTING CONTAINERS..."

docker pull quay.io/coreos/matchbox:latest
docker pull quay.io/coreos/dnsmasq:latest 

systemctl stop systemd-resolved.service