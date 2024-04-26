# Adapted from https://www.thapaliya.com/en/writings/well-documented-makefiles/
.PHONY: help
help: ## Display this help and any documented user-facing targets. Other undocumented targets may be present in the Makefile.
help:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make <target>\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  %-45s %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

.PHONY: helm-lint

helm-lint: ## Run helm linter
	$(MAKE) -BC charts/meta-monitoring lint

MIXIN_PATH := production/loki-mixin
MIXIN_OUT_PATH_META_MONITORING := production/loki-mixin-compiled-meta-monitoring

mixin: ## Create our version of the mixin
	@rm -rf $(MIXIN_PATH)
	./scripts/clone_loki_mixin.sh
	@rm -rf $(MIXIN_OUT_PATH_META_MONITORING) && mkdir $(MIXIN_OUT_PATH_META_MONITORING)
	@cd $(MIXIN_PATH) && jb install
	@mixtool generate all --output-alerts $(MIXIN_OUT_PATH_META_MONITORING)/alerts.yaml --output-rules $(MIXIN_OUT_PATH_META_MONITORING)/rules.yaml --directory $(MIXIN_OUT_PATH_META_MONITORING)/dashboards ${MIXIN_PATH}/mixin-meta-monitoring.libsonnet
	@cp $(MIXIN_OUT_PATH_META_MONITORING)/dashboards/* charts/meta-monitoring/src/dashboards
	@cp $(MIXIN_OUT_PATH_META_MONITORING)/rules.yaml charts/meta-monitoring/src/rules/loki-rules.yaml
