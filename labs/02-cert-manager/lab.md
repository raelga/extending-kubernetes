#### Create the namespace

#### Deploy cert-manager

#### Create a service account to configure the dns challenge

```bash
export PROJECT_ID=<your-project>

$ gcloud beta iam service-accounts create dns01-solver \
  --display-name dns01-solver

$ gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member serviceAccount:dns01-solver@${PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/dns.admin

$ gcloud iam service-accounts keys create /tmp/key.json \
  --iam-account dns01-solver@${PROJECT_ID}.iam.gserviceaccount.com

$ kubectl -n cert-manager create secret generic clouddns-dns01-solver-svc-acct \
  --from-file=/tmp/key.json
```

You can now deploy the issuers

```bash
envsubst '$PROJECT_ID' < le-staging-issuer.yaml | kubectl apply -f -
```

Deploy a certificate for kibana:

```bash
kubectl apply -f kibana-certificate.yaml
```