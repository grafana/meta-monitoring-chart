# Install this chart

1. Create the meta namespace

   ```
   kubectl create namespace meta
   ```

1. Create secrets with credentials and a configmap with the endpoint (as needed) when sending logs, metrics or traces to Grafana Cloud.

   ```
   kubectl create configmap logs-endpoint -n meta \
    --from-literal=endpoint='https://logs-prod-us-central1.grafana.net/loki/api/v1/push'

   kubectl create secret generic logs -n meta \
    --from-literal=username=<logs username> \
    --from-literal=password=<logs password>

   kubectl create configmap metrics-endpoint -n meta \
    --from-literal=endpoint='https://prometheus-us-central1.grafana.net/api/prom/push'

   kubectl create secret generic metrics -n meta \
    --from-literal=username=<metrics username> \
    --from-literal=password=<metrics password>

   kubectl create configmap traces-endpoint -n meta \
    --from-literal=endpoint='https://tempo-us-central1.grafana.net/tempo'

   kubectl create secret generic traces -n meta \
    --from-literal=username=<traces username> \
    --from-literal=password=<traces password>
   ```

1. Create a values.yaml file based on the [default one](../charts/meta-monitoring/values.yaml). Fill in the names of the secrets and configmaps created above as needed.

1. Install this helm chart

   ```
   helm install -n meta -f values.yaml meta ./charts/meta-monitoring
   ```

1. Upgrade

   ```
   helm upgrade --install -f values.yaml -n meta meta ./charts/meta-monitoring
   ```

1. Delete this chart:

   ```
   helm delete -n meta meta
   ```