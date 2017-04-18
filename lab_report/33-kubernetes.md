
## Kubernetes

_(Section by Volodymyr Lubenets)_

### What is kubernetes (k8s)

Being formal, it is an open source container cluster manager. [@wiki_cluster_manager]

Being descriptive, it is a platform, which takes care of managing the docker containers, which were previously described in this document, over the surface of cluster. [@wiki_k8s]

Management is a superclass-expression, which includes automatic or semi-automatic deployment of container VMs,
scheduling (making the running environment i.e. cluster node correspond container requirements), failover management in case the container or a node 
goes down (self-healing) etc.

Also k8s is capable of managing the cluster itself, controlling it's nodes, shared storages of different kind, shared configuration repository
[@coreos_etcd] and also provide the UI for an administrator of the cluster.

Let's take closer look on k8s' features in corresponding section.
As a summary, k8s is a platform merging a cluster manager, a container manager and a tool to control this systems.

### Who needs k8s and what for

Kubernetes is useful for the one who possesses either physical (bare metal), virtual or mixed server park and wants to run a number of services 
(possibly large and fluctuating number) on the whole machine capacity with the ability to control and manage it simply.  
K8s is capable of being managed through HTTP API [@k8s-api], by kubectl [@k8s_kubectl] and by dashboard.

### The key entities in the k8s architecture

The k8s whole infrastructure consists of two key entities, which provide the functionality of the system. (Design doc: [@k8s_design_doc]) Those are:

* Node

  Nodes are the machines, either physical or virtual, which are capable of running at least:
    * container runtime (docker)
    * kubelet (a tool which monitors the state of the node and the pods on it and can change this states if desired)
    * kube-proxy (an ip proxy and load balancer capable of routing the request/response to the correct node i.e. translating outer IP/port to cluster 
    IP/port based on load balancing algorithm and vice versa)
    * cAdvisor (CPU, memory and storage utilization monitor)
    
  Cluster can consist of one to virtually unlimited number of nodes.

* Master

  Master is a node which performs tasks of managing workload of the cluster and handling the direct communication to the it. There is usually one 
  master node in the cluster and possibly several replicas if the high-availability cluster is implemented. 
  Particularly, master runs such services, as:

   * etcd (shared config repo)
   * API server (HTTP server accepting JSONs containing commands)
   * scheduler (a program which assigns pods to nods based on requirements of the former and load of the latter)
   * controller manager (a process which the controllers (*see further*) run in)

### Entities running on top of infrastructure and controlling it

* Pod

  This is higher-level abstraction over containers which ensures that the set of containers (the term of *"the set"* should be understood 
  _one or more_ ) run in the shared environment which includes a single cluster-wide IP (to avoid port collisions over the cluster) and shared storage which 
  can be initialized by pod. Single pod is run on a single node and is migrated as a whole to other node if required.

  A pod is a basic structure being run on the cluster.

* Controller

  This is a program which runs cyclically and drives the cluster from actual to desired state by adding/removing/moving/pausing/launching nodes, using 
  API calls, to keep it simple. One can configure a custom controller, though there are several default ones:

   * Replication controller, which ensures that a number of copies of the pod is being run over cluster
   * DaemonSet controller, which is responsible for the particular pod to be run on each machine of the cluster in single instance
   * JobController, which manages the pods which run to completion as part of batch jobs
    
* Service
  
  The service is a group of pods that work together, which is entitled by a shared label and granted a cluster-wide persistent IP and the DNS record 
  is added to cluster DNS db. This enables service exposure inside the cluster by default, but the service can also be exposed to the outside network 
  if needed. Also the load balancer is activated over the service's pod group.

