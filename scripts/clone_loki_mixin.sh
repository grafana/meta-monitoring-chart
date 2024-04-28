#!/usr/bin/env bash

clean_up() {
  test -d "$tmp_dir" && rm -fr "$tmp_dir"
}

here=${PWD}

tmp_dir=$( mktemp -d -t my-script )
cd $tmp_dir

echo "Cloning Loki"
git clone --filter=blob:none  --no-checkout "https://github.com/grafana/loki"
cd loki
git sparse-checkout init --cone
git checkout main
git sparse-checkout set production/loki-mixin

echo "Copying production/loki-mixin to ${here}"
cp -r production ${here}