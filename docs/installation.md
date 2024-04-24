# Install this chart

## Preparation for Cloud mode (preferred)

1. Use an existing Grafana Cloud account or setup a new one. Then create an access token:

   1. In Grafana go to Administration -> Users and Access -> Cloud access policies.

   1. Click `Create access policy`.

   1. Fill in the `Display name` field and check the `Write` check box for metrics, logs and traces. Then click `Create`.

   1. On the newly created access policy click `Add token`.

   1. Fill in the `Token name` field and click `Create`. Make a copy of the token as it will be used later on.

1. Create the meta namespace

   ```
   kubectl create namespace meta
   ```

1. Create secrets with credentials and the endpoint when sending logs, metrics or traces to Grafana Cloud.

   ```
   kubectl create secret generic logs -n meta \
    --from-literal=username=<logs username> \
    --from-literal=password=<token>
    --from-literal=endpoint='https://logs-prod-us-central1.grafana.net/loki/api/v1/push'

   kubectl create secret generic metrics -n meta \
    --from-literal=username=<metrics username> \
    --from-literal=password=<token>
    --from-literal=endpoint='https://prometheus-us-central1.grafana.net/api/prom/push'

   kubectl create secret generic traces -n meta \
    --from-literal=username=<traces username> \
    --from-literal=password=<token>
    --from-literal=endpoint='https://tempo-us-central1.grafana.net/tempo'
   ```

   The logs, metrics and traces usernames are the `User / Username / Instance IDs` of the Loki, Prometheus/Mimir and Tempo instances in Grafana Cloud. From `Home` in Grafana click on `Stacks`. Then go to the `Details` pages of Loki, Prometheus/Mimir and Tempo.

1. Create a values.yaml file based on the [default one](../charts/meta-monitoring/values.yaml). Fill in the names of the secrets created above as needed. An example minimal values.yaml looks like this:

   ```
   namespacesToMonitor:
   - loki

   cloud:
     logs:
       enabled: true
       secret: "logs"
     metrics:
       enabled: true
       secret: "metrics"
     traces:
       enabled: true
       secret: "traces"
   ```

## Preparation for Local mode

1. Create the meta namespace

   ```
   kubectl create namespace meta
   ```

1. Create a values.yaml file based on the [default one](../charts/meta-monitoring/values.yaml). An example minimal values.yaml looks like this:

   ```
   namespacesToMonitor:
   - loki

   cloud:
     logs:
       enabled: false
     metrics:
       enabled: false
     traces:
       enabled: false

   local:
     grafana:
       enabled:true
     logs:
       enabled: true
     metrics:
       enabled: true
     traces:
       enabled: true
     minio:
       enabled: true
   ```

## Installing the chart

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

