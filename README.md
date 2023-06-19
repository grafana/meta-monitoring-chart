# meta-monitoring-chart

A meta-monitoring chart for GEL, GEM and GET.

## Install this chart

1. Create the meta namespace

   ```
   kubectl create namespace meta
   ```

1. Create a values.yaml file

1. Install this helm chart

   ```
   helm install -n meta meta ./charts/meta-monitoring
   ```

1. Upgrade

   ```
   helm upgrade --install -n meta meta ./charts/meta-monitoring
   ```

1. Delete this chart:

   ```
   helm delete -n meta meta
   ```


## Update dependencies

Run this in the charts/meta-monitoring directory after updating a dependency:

```
helm dependency update meta-monitoring
```

List dependencies:

```
helm dependency list meta-monitoring
```

