import json
from jinja2 import Template
from os import remove, walk
from os.path import join

TEMPLATE_DIR="./templates"
CONFIG_DIR="./config"

with open("hosts.json", "r") as fd:
  hosts_dict = json.load(fd);

hosts = []
for k, v in hosts_dict.iteritems():
  host = v
  host['mac'] = k
  if 'disabled' not in host or not host['disabled']:
    hosts.append(host)  

hosts.sort(key=lambda x: x['name'])

def generate(template, output, **kwargs):
  with open(template, "r") as fd:
    t = Template(fd.read())
  with open(output, "w") as fd:
    fd.write(t.render(**kwargs))

def clean_dir(dir):
  for (dirpath, dirnames, filenames) in walk(dir):
    for f in filenames:
      remove(join(dirpath, f))  


if __name__ == "__main__":
  print "Hosts loaded: " + str(hosts)

  generate(join(TEMPLATE_DIR, "dnsmasq.conf"), join(CONFIG_DIR, "dnsmasq.conf"), hosts=hosts)
  clean_dir(join(CONFIG_DIR, "groups"))
  for host in hosts:
    generate(join(TEMPLATE_DIR, "group.json"), join(CONFIG_DIR, "groups", host['name'] + '.json'), hosts=hosts, host=host)
