{{- define "agent.namespaces" -}}
{{- $list := list }}
{{- range .Values.namespacesToMonitor }}
{{- $list = append $list (printf "\"%s\"" .) }}
{{- end }}
{{- join ", " $list }}
{{- end }}

{{- define "agent.all_namespaces" -}}
{{- $list := list }}
{{- range .Values.namespacesToMonitor }}
{{- $list = append $list (printf "\"%s\"" .) }}
{{- end }}
{{- $list = append $list (printf "\"%s\"" .Release.Namespace) }}
{{- join ", " $list }}
{{- end }}

{{- define "agent.all_namespaces_bar" -}}
{{- $list := list }}
{{- range .Values.namespacesToMonitor }}
{{- $list = append $list (printf "%s" .) }}
{{- end }}
{{- $list = append $list .Release.Namespace }}
{{- join "|" $list }}
{{- end }}

{{- define "agent.loki_write_targets" -}}
{{- $list := list }}
{{- if .Values.local.logs.enabled }}
{{- $list = append $list ("loki.write.local.receiver") }}
{{- end }}
{{- if .Values.cloud.logs.enabled }}
{{- $list = append $list ("loki.write.cloud.receiver") }}
{{- end }}
{{- join ", " $list }}
{{- end }}

{{- define "agent.loki_process_targets" -}}
{{- if and (empty .Values.logs.piiRegexes) (empty .Values.logs.retain) }}
{{- include "agent.loki_write_targets" . }}
{{- else }}
{{- printf "loki.process.filter.receiver" }}
{{- end }}
{{- end }}

{{- define "agent.prometheus_write_targets" -}}
{{- $list := list }}
{{- if .Values.local.metrics.enabled }}
{{- $list = append $list ("prometheus.remote_write.local.receiver") }}
{{- end }}
{{- if .Values.cloud.metrics.enabled }}
{{- $list = append $list ("prometheus.remote_write.cloud.receiver") }}
{{- end }}
{{- join ", " $list }}
{{- end }}

{{- define "agent.tempo_write_targets" -}}
{{- $list := list }}
{{- if .Values.local.traces.enabled }}
{{- $list = append $list ("otelcol.exporter.otlphttp.local.input") }}
{{- end }}
{{- if .Values.cloud.traces.enabled }}
{{- $list = append $list ("otelcol.exporter.otlphttp.cloud.input") }}
{{- end }}
{{- join ", " $list }}
{{- end }}

{{- define "agent.all_logs" -}}
{{- $list := list }}
{{- range .Values.logs.retain }}
{{- $list = append $list . }}
{{- end }}
{{- range .Values.logs.extraLogs }}
{{- $list = append $list . }}
{{- end }}
{{- join "|" $list }}
{{- end }}

{{- define "agent.all_metrics" -}}
{{- $list := list }}
{{- range .Values.metrics.retain }}
{{- $list = append $list . }}
{{- end }}
{{- range .Values.metrics.extraMetrics }}
{{- $list = append $list . }}
{{- end }}
{{- join "|" $list }}
{{- end }}