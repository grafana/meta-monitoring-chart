# Update the dependencies

The dependencies are the versions of Loki, Mimir, Agent and so on that are included in this chart.
The current versions can be found in the [Chart.yaml](../charts/meta-monitoring/Chart.yaml) file.

A Github action runs daily to see if updated versions are available. A PR will be created.

The manual steps are as follows:

Run this in the charts/meta-monitoring directory after updating a dependency:

```
helm dependency update meta-monitoring
```

List the current dependencies:

```
helm dependency list meta-monitoring
```
