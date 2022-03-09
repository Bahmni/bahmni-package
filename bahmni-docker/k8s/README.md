### Start minikube with decent resources

```
minikube start --driver=docker --memory 5000 --cpus=4

you should see

😄  minikube v1.25.2 on Darwin 10.15.7
✨  Using the docker driver based on user configuration
👍  Starting control plane node minikube in cluster minikube
🚜  Pulling base image ...
🔥  Creating docker container (CPUs=4, Memory=5000MB) ...\
```

### Enable Ingress

`minikube addons enable ingress`

### Add nginx ingress entry to etc host

```
sudo vi /etc/hosts

# bahmni kubernetes nginx-ingress
127.0.0.1 bahmni.k8s
```

### Start the tunnel for minicube

`minikube tunnel --alsologtostderr -v=1`

### Create ingress

`kubectl apply -f ingress.yaml`

### Provision hello and echo service

`kubectl apply -f hello.yaml -f echo.yaml`

### Test

```
curl bahmni.k8s/echo

curl bahmni.k8s/hello

```
