
## Trying minikube on Windows

_(Section by Boris Kirikov)_

Minikube is kubernetes distribution that can run locally on developers laptop [@minikube]. It can run on top of any type of host OS because uses VM as a node.
This is the easiest way to get some hands-on experience with kubernetes, so we decided to start with installing minikube on Windows and trying some
basic things.

### Installation (in MB316) {#sec:minikube-install}

  1. Login as local administrator (Username: `cisco`)
  2. From `Win + X` open Control Panel, Programs, Turn Windows features on and off
  3. Enable Hyper-V platform
  4. After feature is enabled, reboot the desktop (should reboot twice)
  5. Check from control panel that feature is enabled
  6. From start menu launch Hyper-V Manager and connect to local machineto verify Hyper-V platform is running
  7. Open Virtual Switch Manager and  Create Private Switch (use name sw1, Connection: External network)
  8. Download [minikube binary](https://storage.googleapis.com/minikube/releases/v0.16.0/minikube-windows-amd64.exe)
  9. Also download [kubectl utility](https://storage.googleapis.com/kubernetes-release/release/v1.5.2/bin/windows/amd64/kubectl.exe)
  10. Run cmd/powershell as admin and CD to directory with binaries
  11. Run `.\minikube.exe start --vm-driver=hyperv --hyperv-virtual-switch=sw1 --insecure-registry localhost:5000` and wait while it starts
  12. Use `.\minikube.exe dashboard` to access k8s web dashboard
  13. Use `.\kubectl.exe` to control cluster from command line
  14. Cluster is ready for testing

### Deploy some container

Let's deploy Keycloak [@keycloak] container [@keycloak-container] as example of using k8s deploy. 

There are several ways of doing it:

  - from web dashboard (press plus button, enter name, container, and variables)
  - from kubectl command
  - from YAML/JSON file describing deployment

Let's do it using CLI:

  1. `.\kubectl.exe run keycloak-test --image=jboss/keycloak --port=8080 --env="KEYCLOAK_USER=admin" --env="KEYCLOAK_PASSWORD=admin"`
  2. Now docker container `jboss/keycloak` is running in cluster, but to access it's web interface we need to define service
  3. `.\kubectl.exe expose deployment keycloak-test --type=NodePort` exposes port of deployment to node
  4. `.\minikube.exe service keycloak-test --url` shows dashboard url
  5. Open it in browser, login as `admin:admin`, keycloak is ready



  