# Bahmni on Kubernetes

Bahmni on Kubernetes can be setup locally using minikube.

## Prerequisites:
1. Install [docker](https://docs.docker.com/engine/install/)
2. Install [minikube](https://minikube.sigs.k8s.io/docs/start/) >=1.25.2
3. Increase resources of your docker to a memory of atleast 8GB. ([Mac](https://docs.docker.com/desktop/mac/) / [Windows](https://docs.docker.com/desktop/windows/))

Note: You can also run minikube without using docker. Look [here](https://minikube.sigs.k8s.io/docs/drivers/).
## Start minikube with decent resources

```
minikube start --driver=docker --memory 7000 --cpus=4 
```
you should see
```
😄  minikube v1.25.2 on Darwin 10.15.7
✨  Using the docker driver based on user configuration
👍  Starting control plane node minikube in cluster minikube
🚜  Pulling base image ...
🔥  Creating docker container (CPUs=4, Memory=7000MB) ...\
```

## Enable Ingress

`minikube addons enable ingress`

## Add nginx ingress entry to etc host

```
sudo vi /etc/hosts

# bahmni kubernetes nginx-ingress
127.0.0.1 bahmni.k8s

# bahmni-odoo kubernetes nginx-ingress
127.0.0.1 erp-bahmni.k8s
```

## Start the tunnel for minikube

`minikube tunnel --alsologtostderr -v=1`

Note: Keep this process running
## Create ingress

``` 
kubectl apply -f bahmni-ingress.yaml 
```

## Provision All Bahmni Resources

```
kubectl apply -R -f . 
```

## Provision Specific Resources

```
kubectl apply -R -f <directory_of_resource>/
```

Example: `kubectl apply -R -f openmrs/`

## View resources

```
 kubectl get all
 ```

 ## Delete all resources

 ```
 kubectl delete -R -f .
 ```
## Accessing Application
Once the pods and servies are running you can access it from the browser on 
1. Bahmni EMR --> https://bahmni.k8s/bahmni/home
2. OpenMRS --> https://bahmni.k8s/openmrs
3. OpenELIS --> https://bahmni.k8s/openelis
4. Odoo --> https://erp-bahmni.k8s/
### References: 
1. [kubectl Commands cheatsheet](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands)
2. [Minikube Docs](https://minikube.sigs.k8s.io/docs/start/)
3. [NGINX Ingress](https://kubernetes.github.io/ingress-nginx/)
4. [Kubernetes API Config](https://kubernetes.io/docs/reference/kubernetes-api/)
