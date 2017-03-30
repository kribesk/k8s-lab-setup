#!/bin/python
from wakeonlan import wol
import json

with open("hosts.json", "r") as fd:
    hosts = json.load(fd)

ip = str(hosts.get(hosts.keys()[0]).get("ip"))
ip = ip[0:ip.rfind(".")+1]+"255"
for mac in hosts.keys():
    #print mac    
    wol.send_magic_packet(mac, ip_address=ip)


