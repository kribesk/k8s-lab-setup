echo ">>>>>>>>>> INSTALLING PACKAGES..."

echo "IPv6 off..."
sysctl net.ipv6.conf.all.disable_ipv6=1
sysctl net.ipv6.conf.default.disable_ipv6=1
sysctl net.ipv6.conf.lo.disable_ipv6=1

apt-get update
apt-get install -y docker.io nfs-kernel-server

if [ ! -d /vagrant/assets/coreos/1235.9.0 ]; then
  echo ">>>>>>>>>> GETTING CORE OS..."
  /vagrant/scripts/get-coreos stable 1235.9.0 ./examples/assets 2> /dev/null
fi

#echo ">>>>>>>>>>> BUILDING CONFIGS..."
#cd /vagrant
#python scripts/make_config.py

echo ">>>>>>>>>> GETTING CONTAINERS..."

docker pull quay.io/coreos/matchbox:latest
docker pull quay.io/coreos/dnsmasq:latest 

echo ">>>>>>>>>>> SETTING STATIC IP..."

cat << EOF > /etc/network/interfaces

# Static ip on bridge interface
auto enp0s8
iface enp0s8 inet static
        address 172.18.0.2
        netmask 255.255.255.0
EOF
echo "namespace 172.18.0.2" > /etc/resolv.conf

#ifdown enp0s8
#ifup enp0s8
systemctl stop systemd-resolved.service
systemctl restart networking

echo ">>>>>>>>>>> SETTING NAT..."
echo 1 > /proc/sys/net/ipv4/ip_forward
sysctl net.ipv4.ip_forward=1
iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE
iptables -A FORWARD -i enp0s3 -o enp0s8 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i enp0s8 -o enp0s3 -j ACCEPT

echo ">>>>>>>>>>> SETTING NFS..."
mkdir /storage
chmod 777 /storage
echo "/storage    *(rw,sync,no_root_squash)" >> /etc/exports
systemctl restart nfs-kernel-server.service 