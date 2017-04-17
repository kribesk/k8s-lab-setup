import json
from jinja2 import Template
from os import remove, walk
from os.path import join

with open("config.json", "r") as fd:
  config = json.load(fd);

TEMPLATE_DIR = config['template_dir']
CONFIG_DIR = config['config_dir']
SSHKEYS_DIR = config['sshkeys_dir']

hosts = []
master = None
for host in config['hosts']:
  if 'disabled' not in host or not host['disabled']:
    hosts.append(host)
  if 'master' in host and host['master']:
    master = host

hosts.sort(key=lambda x: x['name'])

with open(join(SSHKEYS_DIR, "ssh_public")) as fd:
  ssh_public = fd.read()

def generate(template, output, **kwargs):
  print "Generating config: " + template + " > " + output
  with open(template, "r") as fd:
    t = Template(fd.read())
  with open(output, "w") as fd:
    fd.write(t.render(**kwargs))

def clean_dir(dir):
  for (dirpath, dirnames, filenames) in walk(dir):
    for f in filenames:
      remove(join(dirpath, f))  


if __name__ == "__main__":
  generate(join(TEMPLATE_DIR, "dnsmasq.conf"), join(CONFIG_DIR, "dnsmasq.conf"), hosts=hosts)
  clean_dir(join(CONFIG_DIR, "groups"))
  for host in hosts:
    generate(join(TEMPLATE_DIR, "group.json"), join(CONFIG_DIR, "groups", host['name'] + '.json'), hosts=hosts, host=host, master=master)
  print ssh_public
  
