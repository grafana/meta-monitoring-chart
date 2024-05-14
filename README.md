# meta-monitoring-chart

This is a meta-monitoring chart for Loki, specifically Loki installed via the Loki helm chart.

## Local and cloud modes

The chart has 2 modes: local and cloud. In the local mode logs, metrics and/or traces are sent
to small Loki, Mimir and Tempo installations running in the meta-monitoring namespace.

![local mode](docs/images/Meta%20monitoring%20local.png)

In the cloud mode the logs, metrics and/or traces are sent to Grafana Cloud.

![cloud mode](docs/images/Meta%20monitoring%20cloud.png)

Both modes can be enabled at the same time. Cloud mode is preferred.

## Installation

For more instructions including how to install the chart go to the [installation](docs/installation.md) page.

## Supported features

- Specify which namespaces are monitored
- Specify if logs, metrics or traces should be enabled for cloud or local
- Specify the cluster name used for the logs, metrics and traces
- Specify PII regexes that are applied to logs before they are sent to Loki (cloud or local). The capture group in the regex is replaced with *****.
- a Grafana instance is installed (when local mode is used) with the relevant datasources installed. The following dashboards are installed:
  - logs dashboards
  - Alloy dashboards

Most of these features are enabled by default. See the values.yaml file for how to enable/disable them.

## Caveats

- This has not been tested on Openshift yet.
- The underlying Loki, Mimir and Tempo are at the default size installed by the Helm chart. This might need changing when monitoring bigger Loki, Mimir or Tempo installations.
- MinIO is used as storage for the local mode at the moment with a limited retention. At the moment this chart cannot be used for monitoring over longer periods.

## Developer help topics

- [update dependencies](docs/dev_update_dependencies.md)