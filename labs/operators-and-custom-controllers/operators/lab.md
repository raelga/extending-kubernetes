# Lab: operators and the Operator Hub

#### Install the Operator Livecycle Manager

```bash
$ kubectl apply -f labs/01-elasticsearch-operator/olm.yaml
```

#### Install the ElasticSearch operator

```bash
$ kubectl apply -f labs/01-elasticsearch-operator/elastic-cloud-eck.yaml
```

#### Install an ElasticSearch cluster using the operator

```bash
$ kubectl apply -f labs/01-elasticsearch-operator/elasticsearch.yaml
```

Wait for the cluster to be ready by checking the status:

```bash
$ k get elasticsearches.elasticsearch.k8s.elastic.co
NAME            HEALTH   NODES   VERSION   PHASE         AGE
elasticsearch   green    1       7.2.0     Operational   10m
```

To get the password of the ElasticSearch cluster default user:

```bash
$ PASSWORD=$(kubectl get secret elasticsearch-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode)
```

Get the IP of the services where we have exposed ElasticSearch:

```bash
$ IP=$(kubectl get svc elasticsearch-es-http -ojsonpath='{.status.loadBalancer.ingress[0].ip}')
```

You can now curl the elasticsearch endpoint:

```bash
$ curl -u "elastic:$PASSWORD" -k https://$IP:9200
```

#### Install Kibana using the operator

```bash
kubectl apply -f labs/01-elasticsearch-operator/kibana.yaml
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

#### Install a fluent-bit daemon set to send cluster logs to our elasticsearch cluster

```bash
kubectl apply -f labs/01-elasticsearch-operator/fluent-bit.yaml
```

Now create an index patter in kibana and see cluster logs :)