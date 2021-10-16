# Web Server Project 
Simple Project for local minikube web server deployment with:
* Python, Flask
* Terraform, Helm, Docker

## Project structure 
```
infra               # IaC templates
  - helm-chart      # Helm Charts
src                 # Application code
```

## Application
For setup run
```
make development-setup
cd src/
source .venv/bin/activate
```
For test run `make test-app`

## Docker
Build `make docker-build`
Run local `make docker-run-local`

## Minikube deployment
Make sure you have Minikube installed if not > https://minikube.sigs.k8s.io/docs/start/
Then run `make` 
Script will start minikube, enable addons and deploy Web Server

# For Apple Silicon M1 - Ingress Solution
According to this bug https://github.com/kubernetes/minikube/issues/7332
Minikube do not expose ingress and we cannot access server by host or IP, so we need to workaround it.
* Run `make apple-m1-minikube-hack-enable` to open the tunnel and add record to host(requires `sudo` privilage)
* For cleanup run `make apple-m1-minikube-hack-disable`

## Test deployment
Run `make test-deployment` to check is endpoint working

