{{- define "agent.namespaces" -}}
{{- $list := list }}
{{- range .Values.namespacesToMonitor }}
{{- $list = append $list (printf "\"%s\"" .) }}
{{- end }}
{{- join ", " $list }}
{{- end }}
