# Lab: operators and the Operator Hub

#### Create the cluster

```bash
cd labs/operators-and-custom-controllers
terrform init
[...]
terraform apply -auto-approve
[...]
```

#### Get the kubeconfig for the cluster

```bash
gcloud beta container clusters get-credentials extending-k8s --region europe-west4 --project k8s-talks
```

#### Install the Operator Livecycle Manager

```bash
kubectl apply -f operators/olm.yaml
```

#### Install the ElasticSearch operator

```bash
kubectl apply -f operators/elastic-cloud-eck.yaml
```

You can now check the status of the operator using the OLM CRDs

```bash
kubectl get clusterserviceversions.operators.coreos.com
```

And check the new CRDs available in the cluster, managed by the new operator

```bash
k get crd | grep elastic
apmservers.apm.k8s.elastic.co                  2019-09-17T16:35:59Z
elasticsearches.elasticsearch.k8s.elastic.co   2019-09-17T16:35:59Z
kibanas.kibana.k8s.elastic.co                  2019-09-17T16:35:59Z
```

#### Install an ElasticSearch cluster using the operator

```bash
kubectl apply -f operators/elasticsearch.yaml
```

Wait for the cluster to be ready by checking the status:

```bash
k get elasticsearches.elasticsearch.k8s.elastic.co
NAME            HEALTH   NODES   VERSION   PHASE         AGE
elasticsearch   green    1       7.2.0     Operational   10m
```

To get the password of the ElasticSearch cluster default user:

```bash
PASSWORD=$(kubectl get secret elasticsearch-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode)
```

Get the IP of the services where we have exposed ElasticSearch:

```bash
IP=$(kubectl get svc elasticsearch-es-http -ojsonpath='{.status.loadBalancer.ingress[0].ip}')
```

You can now curl the elasticsearch endpoint:

```bash
curl -u "elastic:$PASSWORD" -k https://$IP:9200
```

#### Install Kibana using the operator

```bash
kubectl apply -f operators/kibana.yaml
```

Check kibana status:

```bash
$ k get kibanas.kibana.k8s.elastic.co
NAME     HEALTH   NODES   VERSION   AGE
kibana   green    1       7.2.0     2m33s
```

Get kibana's service IP:

```bash
kubectl get svc kibana-kb-http -ojsonpath='{.status.loadBalancer.ingress[0].ip}'; echo
```

Open `https://<kibana-svc-ip>` in a browser

#### Create DNS records both for Kibana and ElasticSearch

Uncomment the commented lines in the main.tf file and issue the following commands

```bash
terraform init
terraform apply -auto-approve
```

#### Install a fluent-bit daemon set to send cluster logs to our elasticsearch cluster

```bash
kubectl apply -f operators/fluent-bit.yaml
```

Now create an index patter in kibana and see cluster logs :)