{{- define "agent.namespaces" -}}
{{- $list := list }}
{{- range .Values.namespacesToMonitor }}
{{- $list = append $list (printf "\"%s\"" .) }}
{{- end }}
{{- join ", " $list }}
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
{{- if empty .Values.logs.piiRegexes }}
{{- include "agent.loki_write_targets" . }}
{{- else }}
{{- printf "loki.process.PII.receiver" }}
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
{{- $list = append $list ("otelcol.exporter.otlp.local.input") }}
{{- end }}
{{- if .Values.cloud.traces.enabled }}
{{- $list = append $list ("otelcol.exporter.otlp.cloud.input") }}
{{- end }}
{{- join ", " $list }}
{{- end }}