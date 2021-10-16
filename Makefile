IMAGE=apiserver
TAG=0.0.1
# Get minikube ssh port to workaround bug with Minikube and Apple Silicon
PORT=$(shell docker port minikube | grep 22/tcp | cut -d: -f2)
PY_DEPENDENCIES=cd src/; python3 -m venv .venv && source .venv/bin/activate && pip install -rrequirements.txt
.PHONY: all

all: test-app minikube-start minikube-enable-ingress docker-build terraform-apply

test-app:
	@echo "Test API.\n"
	@$(PY_DEPENDENCIES); python -m unittest -v

minikube-start:
	@echo "Start Minikube.\n"
	@minikube start

minikube-enable-ingress:
	@echo  "Enable Minikube Ingress addon.\n"
	@minikube addons enable ingress

docker-build: 
	@echo  "Set Minikube to use local docker repository and build docker image.\n"
	@eval $$(minikube docker-env); \
	docker image build -t $(IMAGE):$(TAG) .

terraform-apply:
	@echo  "Apply infrastructure configuration.\n"
	terraform -chdir=infra/ init
	terraform -chdir=infra/ apply -auto-approve -var="image_tag=$(TAG)"

# For Apple Silicon
apple-m1-minikube-hack-enable:
	@echo  "Enable workaround for Apple Silicon M1.(Adds hosts record and starts tunnel)\n"
	@echo 127.0.0.1 local.ecosia.org | sudo tee -a /etc/hosts > /dev/null
	@sudo ssh \
		-o UserKnownHostsFile=/dev/null \
		-o StrictHostKeyChecking=no \
		-N docker@127.0.0.1 \
		-p $(PORT) \
		-i /Users/$(USER)/.minikube/machines/minikube/id_rsa \
		-L 80:127.0.0.1:80 & 
	@sleep 1

# For Apple Silicon
apple-m1-minikube-hack-disable:
	@echo "Disable workaround for Apple Silicon M1. (Remove hosts record and stops tunnel)\n"
	@sudo sed -i .bak '/^127\.0\.0\.1[[:space:]]local\.ecosia\.org/d' /etc/hosts
	@ps ax | grep '[s]sh.*$(USER)' | awk '{print $$1}' | sudo xargs kill -9

test-deployment:
	@echo  "Make request to check is deployment.\n\n"
	curl local.ecosia.org/tree
	@echo "\n\n"

test-deployment-apple-m1: apple-m1-minikube-hack-enable test-deployment apple-m1-minikube-hack-disable

development-setup:
	@echo  "Setup development environment.\n"
	@$(PY_DEPENDENCIES)

docker-run-local:
	@echo  "Running local docker.\n"
	docker run -p 5000:5000 --name apiserver_dev $(IMAGE):$(TAG)