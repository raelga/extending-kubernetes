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
docker-build                   OPERATOR IMAGE - Build operator Docker image
docker-push                    OPERATOR IMAGE - Push operator Docker image to remote registry
docker-update                  OPERATOR IMAGE - Build and Push operator Docker image to remote registry
create-crd                     CustomResourceDefinition - Create Operator CRD
delete-crd                     CustomResourceDefinition - Delete Operator CRD
create-operator                OPERATOR - Create/Update Operator objects (remember to set correct image on deploy/operator.yaml)
delete-operator                OPERATOR - Delete Operator objects
view-operator-main-logs        OPERATOR - View logs from operator container inside operator deployment
view-operator-ansible-logs     OPERATOR - View logs from ansible container inside operator deployment
create-cr                      CustomResource - Create/Update CR example
delete-cr                      CustomResource - Delete CR example
get-cr                         CustomResource - Get current CRs
describe-cr                    CustomResource - Describe CR example
describe-cr-deployment         CustomResource - Describe created deployment for example CR
describe-cr-service            CustomResource - Describe created service for example CR
all                            MAIN - Create all: CRD, Operator, CR
clean                          MAIN - Clean all resources: CR, Operator, CRD
help                           MAIN - Print this help
```

## Operator image creation

* Once you have added changes to ansible operator, create new operator image and push it to registry with:

```bash
$ make docker-update
```

## End-to-end test


* Make sure you have installed `kubectl` client on your machine, and you are authenticated within a k8s cluster:

* Execute `all` target that will create all needed objects:

```bash
$ make all
```

* Once tested, execute `clean` target that will delete all created objects:

```bash
$ make clean
```
