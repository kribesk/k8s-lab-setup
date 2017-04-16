#!/bin/python
from wakeonlan import wol
import json

with open("config.json", "r") as fd:
  config = json.load(fd);

hosts = []
for host in config['hosts']:
  if 'disabled' not in host or not host['disabled']:
    hosts.append(host)  

hosts.sort(key=lambda x: x['name'])

ip = str(hosts[0].get("ip"))
ip = ip[0:ip.rfind(".")+1]+"255"

for host in hosts:
    print host['mac']
    for _ in range(10):
      wol.send_magic_packet(host['mac'], ip_address=ip)


