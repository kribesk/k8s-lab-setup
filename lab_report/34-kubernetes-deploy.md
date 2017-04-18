
## Deployment object of k8s environment

_(Section by Volodymyr Lubenets)_

K8s environment is an infrastructure which key feature is fast and convenient mechanism to deploy needed services. This feature is called "deployment config". [@k8s_deployments]

The absolute minimum which a deployment config has to specify is the container which is supposed to run inside the `Pod` created by a deployment.

This config may contain all the information to provision the environment which is required by the service:

* CPU and RAM requirements
* Claims for temporary and persistent storages [@sec:persistence]
* Networking and load balancing (ingresses and services) [@sec:exposure]
* Replication and replication strategy (`ReplicaSet` object directive maintains N instances of a `Pod` running on a cluster)
* Environment variables and startup commands, if any

etc.

A remarkable feature of `Deployment` is that it may be used to perform rolling updates of existing `Deployment`s. This is done by editing the YAML of a `Deployment` which is already on the cluster.  
Documentation example shows such action:

```bash
$ kubectl set image deployment/nginx-deployment nginx=nginx:1.9.1
deployment "nginx-deployment" image updated
```

In here, the image version is changed. This change leads to automatic loading and rolling out new version of nginx, as seen here (again quote from the doc):

```bash
$ kubectl rollout status deployment/nginx-deployment
Waiting for rollout to finish: 2 out of 3 new replicas have been updated...
deployment "nginx-deployment" successfully rolled out
```

To get a full overview on this feature, a reader can check out the `config/nfs-provisioner-deployment/nfs_prov.yaml`. Features like allocation storage and setting environment variables is observable there.
