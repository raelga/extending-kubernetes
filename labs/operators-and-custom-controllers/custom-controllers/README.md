#### Deploy cert-manager

```bash
kubectl apply -f custom-controllers/cert-manager.yaml
```

#### Create a service account to configure the dns challenge

```bashcom
gcloud beta iam service-accounts create dns01-solver \
  --display-name dns01-solver

gcloud projects add-iam-policy-binding k8s-talks \
  --member serviceAccount:dns01-solver@k8s-talks.iam.gserviceaccount.com \
  --role roles/dns.admin

gcloud iam service-accounts keys create /tmp/key.json \
  --iam-account dns01-solver@k8s-talks.iam.gserviceaccount.com

kubectl -n cert-manager create secret generic clouddns-dns01-solver-svc-acct \
  --from-file=/tmp/key.json
```

#### Create the certificate issuer with dns-01 challenge

```bash
kubectl apply -f custom-controllers/le-issuer.yaml
```

#### Deploy a certificate for kibana

```bash
kubectl apply -f custom-controllers/kibana-certificate.yaml
```

Uncomment the TLS related lines from kibana.yaml in the previous lab, apply the changes and access kibana from a browser.

```bash
kubectl apply -f operators/kibana.yaml
```