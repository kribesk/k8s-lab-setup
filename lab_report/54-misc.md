
## Other notes

_(Section by Volodymyr Lubenets)_

### K8s persistent storage

The matter of using a containerized deployment is simple -- a container is a consolidated thing with all the needed pieces of software inside, from OS to service itself. The stateless applications run just like this -- an independent piece of software answers the queries which change nothing in it (cache perhaps).

However, one can need to run some stateful apps on the cluster (e.g. databases, game servers etc.)  
How to do this? The way is to allocate a persistent storage and grant a right to use it to the application.  
K8s is capable of doing so.

Manual mechanism is simple.  
Just like a deployment, cluster administrator writes a YAML file of a k8s object with type "PersistentStorage", notes its name, optionally tier (as many deployments by default prefer some exact tier name, e.g. "standard")

### Exposing services is not so simple

...service types: clusterip, nodeport and external balances...

...new way/our way: ingresses with load balancer in container...


