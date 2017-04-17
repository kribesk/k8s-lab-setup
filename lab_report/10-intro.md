
# Introduction

The times when the software was targeted to a single machine unit have passed long ago when the very first commercial web service was introduced. The word web (i.e. 
network) brought user asymmetry so that the word “server” got its modern meaning – machine, serving one-to-many. The word commercial (i.e. business) called for 
reliability, redundancy and resiliency, so that the smallest downtime in the functionality of the service would mean lost profits.

With the growth of the web service popularity it proved that hosting one’s infrastruc-ture in one’s own premises is usually (not taking extreme cases into account) 
more expensive than renting the computational and storage volume from the company managing a datacenter, as the company provides servicing of multiple clients in bunch.
Even more price reduction and client capacity was achieved with the applica-tion of hypervisors, which provided the possibility to run multiple virtual machines on a 
single hardware unit by dividing the physical resource capacity among them.

It was a good approach still widely used around the World’s datacenters, however, the load was growing rapidly and physical virtualization turned out to be incapable 
of solving two problems: ease of scalability for really large systems (those which re-quirements could not be satisfied by the capacity of one physical server) and 
load balancing.

And this is where container approach came into play. This approach takes into ac-count that most web services do not require separate OS environment and can be 
represented by conjunction of server software, configs, database and static data. Other than that, web services are mostly stateless, which means that no specific 
session information is stored in real time on the server between user requests, each request is fully processed “in single shot”. This gives the possibility of 
building the cluster infrastructure where the load is balanced over several machines containing replicas of containers on them so that each container could respond 
to user request.

And we are on this course to study exactly the latter approach.

## fabric8: continuous integration, code repository, build server and a lot more

Git is supposed to be used as code repository. It is simple, there are many plugins supporting hooks to notify building software on code updates. New code from the 
developers goes here, e.g. merging development branch with the master branch triggers CI server.

CI server performs three workflow steps: building application (compilation & link-age), launching unit-tests on a fresh build and, if a build had proven to be 
successful, wrapping it to the form of Docker container.

## Cluster management platform – orchestrator

This is the cluster management platform with the large bunch of functions. The most important for us include the examining of the state of cluster machines, 
deploying containers to them, balancing load over them and scheduling, which is the possibility for an administrator to specify how the certain container is run 
on a host machine.

Other than that, kubernetes provides the module named etcd which is responsible for storing shared configs of hosts and maintaining service information.

