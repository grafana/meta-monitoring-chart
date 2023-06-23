# Install this chart

1. Create the meta namespace

   ```
   kubectl create namespace meta
   ```

1. Create a values.yaml file based on the [default one](../charts/meta-monitoring/values.yaml).

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