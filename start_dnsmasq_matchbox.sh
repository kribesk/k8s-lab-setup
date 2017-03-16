cd /vagrant/matchbox

sudo docker run --name matchbox -p 8080:8080 -d \
 -v /vagrant/config:/var/lib/matchbox:Z \
 -v /vagrant/matchbox/examples/assets:/var/lib/matchbox/assets:Z \
 quay.io/coreos/matchbox:latest -address=0.0.0.0:8080 -log-level=debug
 
sudo docker run --name dnsmasq --cap-add=NET_ADMIN -d \
 -v /vagrant/config/dnsmasq.conf:/etc/dnsmasq.conf:Z \
 --net=host \
 quay.io/coreos/dnsmasq:latest