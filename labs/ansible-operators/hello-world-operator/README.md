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
  image: "raelga/cats:neu"
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

## Demo script

* Get kubeconfig for the demo k8s cluster:
```
gcloud container clusters get-credentials extending-k8s --project k8s-talks --zone europe-west4
```

* Get current `AnsibleHelloWorld` resources (k8s API gives error, k8s API has not been yet extended with new CRD):
```
kubectl get ansiblehelloworlds
error: the server doesn't have a resource type "ansiblehelloworlds"
```

* Create CRD (so extending k8s API with new resource kind):
```
kubectl create -f deploy/crds/ansiblehelloworld_v1alpha1_ansiblehelloworld_crd.yaml
customresourcedefinition.apiextensions.k8s.io/ansiblehelloworlds.ansible-hello-world.operator.com created
```

* Check again current `AnsibleHelloWorld` resources (now API does not give error, just `Not found` because it has not been yet created any CR of kind `AnsibleHelloWorld`):
```
kubectl get ansiblehelloworlds
No resources found.
```

* Create operator objects:
```
kubectl create -f deploy/service_account.yaml
kubectl create -f deploy/role.yaml
kubectl create -f deploy/role_binding.yaml
kubectl create -f deploy/operator.yaml
kubectl get pods -w
```

* Check operator container logs:
```
kubectl logs deployment/hello-world-operator -c operator --follow
kubectl logs deployment/hello-world-operator -c ansible --follow
```

* Create new `example` `AnsibleHelloWorld` CR (operator will use the spec to create desired objects on the cluster, Deployment/Service):
```
kubectl create -f deploy/crds/ansiblehelloworld_v1alpha1_ansiblehelloworld_cr.yaml
```

* Check operator ansible container log, 3 tasks OK (Gather Facts/Deployment/Service) and 2 tasks changed (Deployment/Service):
```
kubectl logs deployment/hello-world-operator -c ansible --follow
```

* Check again current `AnsibleHelloWorld` resources (now we have one `AnsibleHelloWorld` resource called `example`), you can describe it:
```
kubectl get ansiblehelloworlds
kubectl describe ansiblehelloworld example
```

* Check public IP of `example-hello-world` Service (GKE L4 LoadBalancer) and open web browser, you will see a cat:
```
kubectl get service example-hello-world
```

* Update `example` `AnsibleHelloWorld` CR by changing image to deploy (another cat):
```
vim deploy/crds/ansiblehelloworld_v1alpha1_ansiblehelloworld_cr.yaml
kubectl apply -f deploy/crds/ansiblehelloworld_v1alpha1_ansiblehelloworld_cr.yaml
```

* On next operator `reconcilePeriod`, operator will read new spec and apply required changes on deployed resources (creating a new `Replicaset` inside `example-hello-world` `Deployment`):
```
kubectl logs deployment/hello-world-operator -c ansible --follow
kubectl describe deployment/example-hello-world
```

* Once new deployment have been triggered (new Pod running and serving traffic), open again web browser and you will see a different cat:
```
kubectl get pods -w
```

* Finally, clean all created resources:
```
kubectl delete -f deploy/crds/ansiblehelloworld_v1alpha1_ansiblehelloworld_cr.yaml || true
kubectl delete -f deploy/operator.yaml || true
kubectl delete -f deploy/role_binding.yaml || true
kubectl delete -f deploy/role.yaml || true
kubectl delete -f deploy/service_account.yaml || true
kubectl delete -f deploy/crds/ansiblehelloworld_v1alpha1_ansiblehelloworld_crd.yaml || true
```

* If you check if there is any `AnsibleHelloWorld` resource, we will obtain from k8s API a similar error obtained at the beginning:
```
kubectl get ansiblehelloworlds
Error from server (NotFound): Unable to list "ansible-hello-world.operator.com/v1alpha1, Resource=ansiblehelloworlds": the server could not find the requested resource (get ansiblehelloworlds.ansible-hello-world.operator.com)
```
