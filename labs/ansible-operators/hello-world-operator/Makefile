.PHONY: docker-build docker-push docker-update create-namespace switch-namespace delete-namespace create-crd delete-crd create-operator delete-operator create-cr delete-cr all clean help

.DEFAULT_GOAL := help

MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
THISDIR_PATH := $(patsubst %/,%,$(abspath $(dir $(MKFILE_PATH))))

IMAGE ?= slopezz/ansible-k8s-hello-world-operator
VERSION ?= v1.0.0
NAMESPACE ?= ansible-hello-world

docker-build: ## Build operator Docker image
	operator-sdk build $(IMAGE):$(VERSION)

docker-push: ## Push operator Docker image to remote registry
	docker push $(IMAGE):$(VERSION)

docker-update: docker-build docker-push ## Build and Push operator Docker image to remote registry

create-namespace: ## Create Namespace for the operator
	kubectl create namespace $(NAMESPACE) || true

delete-namespace: ## Delete Namespace for the operator
	kubectl delete --force namespace $(NAMESPACE) || true

create-crd: ## Create Operator CRD
	kubectl create -f deploy/crds/ansiblehelloworld_v1alpha1_ansiblehelloworld_crd.yaml -n $(NAMESPACE) || true

delete-crd: ## Delete Operator CRD
	kubectl delete -f deploy/crds/ansiblehelloworld_v1alpha1_ansiblehelloworld_crd.yaml -n $(NAMESPACE) || true

create-operator: ## Create/Update Operator objects (remember to set correct image on deploy/operator.yaml)
	kubectl apply -f deploy/service_account.yaml -n $(NAMESPACE)
	kubectl apply -f deploy/role.yaml -n $(NAMESPACE)
	kubectl apply -f deploy/role_binding.yaml -n $(NAMESPACE)
	kubectl apply -f deploy/operator.yaml -n $(NAMESPACE) 

delete-operator: ## Delete Operator objects
	kubectl delete -f deploy/operator.yaml -n $(NAMESPACE) || true
	kubectl delete -f deploy/role_binding.yaml -n $(NAMESPACE) || true
	kubectl delete -f deploy/role.yaml -n $(NAMESPACE) || true
	kubectl delete -f deploy/service_account.yaml -n $(NAMESPACE) || true

create-cr: ## Create/Update CR example
	kubectl apply -f deploy/crds/ansiblehelloworld_v1alpha1_ansiblehelloworld_cr.yaml -n $(NAMESPACE) 

delete-cr: ## Delete CR example
	kubectl delete -f deploy/crds/ansiblehelloworld_v1alpha1_ansiblehelloworld_cr.yaml -n $(NAMESPACE) || true

view-ansible-logs: ## View logs from ansible container inside operator deployment
	kubectl logs deployment/hello-world-operator -c ansible --follow -n $(NAMESPACE)

view-operator-logs: ## View logs from operator container inside operator deployment
	kubectl logs deployment/hello-world-operator -c operator --follow -n $(NAMESPACE)

describe-cr-deployment: ## Describe created deployment for example CR
	kubectl describe deployment/example-hello-world -n $(NAMESPACE)

describe-cr-service: ## Describe created service for example CR
	kubectl describe service/example-hello-world -n $(NAMESPACE)

all: create-namespace create-crd create-operator create-cr ## Create all: Namespace, CRD, Operator, CR

clean: delete-cr delete-operator delete-crd delete-namespace ## Clean all resources: CR, Operator, CRD, Namespace

help: ## Print this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
