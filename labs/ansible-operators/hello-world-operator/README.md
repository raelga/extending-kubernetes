# Ansible hello-world-operator

Ansible operator to setup hello-world-operator on Kubernetes

Needed objects to create:
* CRD (one per OCP Cluster)
* role (one per Namespace)
* role_binding (one per Namespace)
* service_account (one per Namespace)
* Operator Deployment (one per Namespace)
* CRs (N per Namespace)

## CR example

* In order to create a specific Custom Resource of `AnsibleHelloWorld` kind (you can create multiple on same Namespace), you just need to create an specific CR, for example:
 
```
apiVersion: ansible-hello-world.operator.com/v1alpha1
kind: AnsibleHelloWorld
metadata:
  name: example
spec:
  image: "gcr.io/google-samples/hello-app:1.0"
  replicas: 1
  requestsCpu: "50m"
  requestsMemory: "32Mi"
  limitsMpu: "100m"
  limitsMemory: "64Mi"
```

* Each `AnsibleHelloWorld` CR will contain `name` string on all created k8s objects (to differenciate among different possible AnsibleHelloWorld CRs inside same namespace).
 
## Usage

```bash
$ make
docker-build                   Build operator Docker image
docker-push                    Push operator Docker image to remote registry
docker-update                  Build and Push operator Docker image to remote registry
create-namespace               Create Namespace for the operator
delete-namespace               Delete Namespace for the operator
create-crd                     Create Operator CRD
delete-crd                     Delete Operator CRD
create-operator                Create/Update Operator objects (remember to set correct image on deploy/operator.yaml)
delete-operator                Delete Operator objects
create-cr                      Create/Update CR example
delete-cr                      Delete CR example
view-ansible-logs              View logs from ansible container inside operator deployment
view-operator-logs             View logs from operator container inside operator deployment
describe-cr-deployment         Describe created deployment for example CR
describe-cr-service            Describe created service for example CR
all                            Create all: Namespace, CRD, Operator, CR
clean                          Clean all resources: CR, Operator, CRD, Namespace
help                           Print this help
```

## Operator image creation

* Once you have added changes to ansible operator, create new operator image and push it to registry with:

```bash
$ make docker-update
```

## End-to-end test


* Make sure you have installed `kubectl` client on your machine, and you are authenticated within a k8s cluster:

```bash
$ kubectl login -u admin https://master.k8s.com:8443
```

* Execute `all` target that will create all needed objects (you can overwrite target namespace with `NAMESPACE` var):

```bash
$ make all
```

* Once tested, execute `clean` target that will delete all created objects (you can overwrite target namespace with `NAMESPACE` var):

```bash
$ make clean
```
