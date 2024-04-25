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

## Installing the dashboards and rules on Grafana Cloud

## Installing the dashboards on Grafana Cloud

Only the files for the application monitored have to be copied. When monitoring Loki import dashboard files starting with 'loki-'.

For each of the dashboard files in charts/meta-monitoring/src/dashboards folder do the following:

1. Click on 'Dashboards' in Grafana

1. Click on the 'New` button and select 'Import'

1. Drop the dashboard file to the 'Upload dashboard JSON file' drop area

1. Click 'Import'

## Installing the rules on Grafana Cloud

1. Select the rules files in charts/meta-monitoring/src/rules for the application to monitor. When monitoring Loki use loki-rules.yaml.

1. Install mimirtool as per the [instructions](https://grafana.com/docs/mimir/latest/manage/tools/mimirtool/)

1. Create an access policy with Read and Write permission for Rules. Also create a token and record the token.

1. Get your cloud Prometheus endpoint and Instance ID from the `Prometheus` page in `Stacks`.

1. Use them to load the rules using mimirtool as follows:

  ```
  mimirtool rules load --address=<your_cloud_prometheus_endpoint> --id=<your_instance_id> --key=<your_cloud_access_policy_token> *.yaml
  ```

1. To check the rules you have uploaded run:

  ```
  mimirtool rules print --address=<your_cloud_prometheus_endpoint> --id=<your_instance_id> --key=<your_cloud_access_policy_token>
  ```