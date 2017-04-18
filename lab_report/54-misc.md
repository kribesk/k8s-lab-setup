
## Other notes

_(Section by Volodymyr Lubenets)_

### K8s persistent storage

The matter of using a containerized deployment is simple -- a container is a consolidated thing with all the needed pieces of software inside, from OS to service itself. The stateless applications run just like this -- an independent piece of software answers the queries which change nothing in it (cache perhaps).

However, one can need to run some stateful apps on the cluster (e.g. databases, game servers etc.)  
How to do this? The way is to allocate a persistent storage and grant a right to use it to the application.  
K8s is capable of doing so.

Manual mechanism is simple.  
Just like a deployment, cluster administrator writes a YAML file of a k8s object with type "PersistentStorage", notes its name, tier name, capacity and the disk/cloud/NAS/SAN where to allocate storage from.

Like this [@k8s_persistence]:

```
apiVersion: v1
  kind: PersistentVolume
  metadata:
    name: pv0003
  spec:
    capacity:
      storage: 5Gi
    accessModes:
      - ReadWriteOnce
    persistentVolumeReclaimPolicy: Recycle
    storageClassName: slow
    nfs:
      path: /tmp
      server: 172.18.0.2
```

After this, storage is created. Until bound, it is free to be used by any application *claiming* for that. So, the application should make a `PersistentVolumeClaim`, which is likewise deployed to k8s by json config.

Like this [@k8s_persistence]:

```
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: myclaim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
  storageClassName: slow
```
After this, the cluster automatically binds the claim to the available storage and the application can save its data there.

It's all good until we have to deploy large quantity of stateful applications (perhaps, automatically). In this case, one should consider automatic provisioning of the PersistentVolume's.

### Automatic persistent storage provisioning from a pool

The desired algorithm is simple:

1. Claim desired volume (size, name, storage tier)
2. Have it provisioned on the cluster as `PersistentVolume`
3. Have it bound to the claim
4. Utilize it

K8s has such mechanism implemented with the `StorageClass` k8s object. It serves two needs -- defines the pool and its tier (just a string, "fast", "standard" and "slow" are conventional but other can be used) and maps a `StorageClass` to a provisioner.

Provisioner is an application which takes care of allocating needed storages and monitoring the overall state of the storage pool.  
There can be many provisioners depending on the platform they use:

* Amazon AWS EBS
* Google GCE PD
* NFS provisioner (the one we have built)
* etc.

Cloud provisioners are built in the k8s core, so only StorageClass declaration is needed to start working.
NFS provisioner is not standard one, so one should build the Pod running the provisioner container and only then declare a StorageClass.

Example StorageClass declaration:

```
kind: StorageClass
apiVersion: storage.k8s.io/v1beta1
metadata:
  name: standard
provisioner: example.com/nfs-provisioner
```

By using this, any claim for the `"standard"` tier storage will be satisfied with on-the-fly allocated volume from NFS server until it is full.

### Exposing services is not so simple

If it comes to the networking inside the cluster, it is not only about physical node NIC addressing. Any container has its IP in the Pod network, any Pod is also addressed across the cluster

...service types: clusterip, nodeport and external balances...

...new way/our way: ingresses with load balancer in container...


