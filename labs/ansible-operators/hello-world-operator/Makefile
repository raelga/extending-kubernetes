.PHONY: docker-build docker-push docker-update create-crd delete-crd create-operator delete-operator create-cr delete-cr all clean help
.DEFAULT_GOAL := help

MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
THISDIR_PATH := $(patsubst %/,%,$(abspath $(dir $(MKFILE_PATH))))

IMAGE ?= slopezz/ansible-k8s-hello-world-operator
VERSION ?= extending-kubernetes
NAMESPACE ?= ansible-hello-world

docker-build: ## OPERATOR IMAGE - Build operator Docker image
	operator-sdk build $(IMAGE):$(VERSION)

docker-push: ## OPERATOR IMAGE - Push operator Docker image to remote registry
	docker push $(IMAGE):$(VERSION)

docker-update: docker-build docker-push ## OPERATOR IMAGE - Build and Push operator Docker image to remote registry

create-crd: ## CustomResourceDefinition - Create Operator CRD
	kubectl create -f deploy/crds/ansiblehelloworld_v1alpha1_ansiblehelloworld_crd.yaml || true

delete-crd: ## CustomResourceDefinition - Delete Operator CRD
	kubectl delete -f deploy/crds/ansiblehelloworld_v1alpha1_ansiblehelloworld_crd.yaml || true

create-operator: ## OPERATOR - Create/Update Operator objects (remember to set correct image on deploy/operator.yaml)
	kubectl apply -f deploy/service_account.yaml
	kubectl apply -f deploy/role.yaml
	kubectl apply -f deploy/role_binding.yaml
	kubectl apply -f deploy/operator.yaml

delete-operator: ## OPERATOR - Delete Operator objects
	kubectl delete -f deploy/operator.yaml || true
	kubectl delete -f deploy/role_binding.yaml || true
	kubectl delete -f deploy/role.yaml || true
	kubectl delete -f deploy/service_account.yaml || true

view-operator-main-logs: ## OPERATOR - View logs from operator container inside operator deployment
	kubectl logs deployment/hello-world-operator -c operator --follow

view-operator-ansible-logs: ## OPERATOR - View logs from ansible container inside operator deployment
	kubectl logs deployment/hello-world-operator -c ansible --follow

create-cr: ## CustomResource - Create/Update CR example
	kubectl apply -f deploy/crds/ansiblehelloworld_v1alpha1_ansiblehelloworld_cr.yaml

delete-cr: ## CustomResource - Delete CR example
	kubectl delete -f deploy/crds/ansiblehelloworld_v1alpha1_ansiblehelloworld_cr.yaml || true

get-cr: ## CustomResource - Get current CRs
	kubectl get ansiblehelloworlds

describe-cr: ## CustomResource - Describe CR example
	kubectl describe ansiblehelloworld example

describe-cr-deployment: ## CustomResource - Describe created deployment for example CR
	kubectl describe deployment/example-hello-world

describe-cr-service: ## CustomResource - Describe created service for example CR
	kubectl describe service/example-hello-world

all: create-crd create-operator create-cr ## MAIN - Create all: CRD, Operator, CR

clean: delete-cr delete-operator delete-crd ## MAIN - Clean all resources: CR, Operator, CRD

help: ## MAIN - Print this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
