# Create a new release

1. Update the version field in charts/meta-monitoring/Chart.yaml in a new PR. Merge this PR if approved.

2. On the [Actions tab](https://github.com/grafana/meta-monitoring-chart/actions):
   - Select `Release Helm chart` in the workflows on the left
   - Click the `Run workflow` button
   - Leave the `main` branch as is
   - Click the green `Run workflow` button

