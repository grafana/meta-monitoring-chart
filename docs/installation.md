# Install this chart

1. Create the meta namespace

   ```
   kubectl create namespace meta
   ```

1. Create secrets with credentials and the endpoint when sending logs, metrics or traces to Grafana Cloud.

   ```
   kubectl create secret generic logs -n meta \
    --from-literal=username=<logs username> \
    --from-literal=password=<logs password>
    --from-literal=endpoint='https://logs-prod-us-central1.grafana.net/loki/api/v1/push'

   kubectl create secret generic metrics -n meta \
    --from-literal=username=<metrics username> \
    --from-literal=password=<metrics password>
    --from-literal=endpoint='https://prometheus-us-central1.grafana.net/api/prom/push'

   kubectl create secret generic traces -n meta \
    --from-literal=username=<traces username> \
    --from-literal=password=<traces password>
    --from-literal=endpoint='https://tempo-us-central1.grafana.net/tempo'
   ```

1. Create a values.yaml file based on the [default one](../charts/meta-monitoring/values.yaml). Fill in the names of the secrets created above as needed.

1. Add the repo

   ```
   helm repo add grafana https://grafana.github.io/helm-charts
   ```

1. Fetch the latest charts from the grafana repo

   ```
   helm repo update grafana
   ```


1. Install this helm chart

   ```
   helm install -n meta -f values.yaml meta grafana/meta-monitoring
   ```

1. Upgrade

   ```
   helm upgrade --install -f values.yaml -n meta meta grafana/meta-monitoring
   ```

1. Delete this chart:

   ```
   helm delete -n meta meta
   ```