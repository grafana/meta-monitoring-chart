# meta-monitoring-chart

This is a meta-monitoring chart for GEL, GEM and GET. It should be installed in a
separate namespace next to GEM, GEL or GET installations.

Note that this is pre-production software at the moment.

## Preparation

Create a values.yaml file based on the [default one](../charts/meta-monitoring/values.yaml).

1. Add or remove the namespaces to monitor in the `namespacesToMonitor` setting

1. Set the cluster name in the `clusterName` setting. This will be added as a label to all logs, metrics and traces.

1. Create a `meta` namespace.

## Local and cloud modes

The chart has 2 modes: local and cloud. In the local mode logs, metrics and/or traces are sent
to small Loki, Mimir and Tempo installations running in the meta-monitoring namespace.

![local mode](docs/images/Meta%20monitoring%20local.png)

To enable local mode set `local.<logs|metrics|traces>.enabled` to true.

In the cloud mode the logs, metrics and/or traces are sent to Grafana Cloud.

![cloud mode](docs/images/Meta%20monitoring%20cloud.png)

To enable cloud mode set `cloud.<logs|metrics|traces>.enabled` to true. The `endpoint`, `username` and `password` settings for your Grafana Cloud logs, metrics and traces instances have to be filled in as well.

Both modes can be enabled at the same time.

## Installation

```
helm install -n meta --skip-crds -f values.yaml meta ./charts/meta-monitoring
```

If the platform supports CRDs the `--skip-crds` option can be removed. However the CRDs are not used by this chart.

For more instructions including how to update the chart go to the [installation](docs/installation.md) page.

## Supported features

- Specify which namespaces are monitored
- Specify if logs, metrics or traces should be enabled for cloud or local
- Specify the cluster name used for the logs, metrics and traces
- Specify PII regexes that are applied to logs before they are sent to Loki (cloud or local). The capture group in the regex is replaced with *****.
- a Grafana instance is installed (when local mode is used) with the relevant datasources installed. The following dashboards are installed:
  - logs dashboards
  - metrics dashboards
  - traces dashboards
  - agent dashboards
- Retention is set to 24 hours

Most of these features are enabled by default. See the values.yaml file for how to enable/disable them.

## Caveats

- The [loki.source.kubernetes](https://grafana.com/docs/agent/latest/flow/reference/components/loki.source.kubernetes/) component of the Grafana Agent is used to scrape Kubernetes log files. This component is marked experimental at the moment.
- This has not been tested on Openshift yet.
- The underlying Loki, Mimir and Tempo are at the default size installed by the Helm chart. This might need changing when monitoring bigger Loki, Mimir or Tempo installations.
- MinIO is used as storage at the moment with a limited retention. At the moment this chart cannot be used for monitoring over longer periods.
- Agent self monitoring is not done at the moment.

## Developer help topics

- [update dependencies](docs/dev_update_dependencies.md)