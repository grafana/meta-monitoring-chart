{{/*
Return the appropriate apiVersion for ingress.
*/}}
{{- define "ingress.apiVersion" -}}
  {{- if and (.Capabilities.APIVersions.Has "networking.k8s.io/v1") (semverCompare ">= 1.19-0" .Capabilities.KubeVersion.Version) -}}
      {{- print "networking.k8s.io/v1" -}}
  {{- else if .Capabilities.APIVersions.Has "networking.k8s.io/v1beta1" -}}
    {{- print "networking.k8s.io/v1beta1" -}}
  {{- else -}}
    {{- print "extensions/v1beta1" -}}
  {{- end -}}
{{- end -}}

{{/*
Return if ingress is stable.
*/}}
{{- define "ingress.isStable" -}}
  {{- eq (include "ingress.apiVersion" .) "networking.k8s.io/v1" -}}
{{- end -}}

{{/*
Return if ingress supports ingressClassName.
*/}}
{{- define "ingress.supportsIngressClassName" -}}
  {{- or (eq (include "ingress.isStable" .) "true") (and (eq (include "ingress.apiVersion" .) "networking.k8s.io/v1beta1") (semverCompare ">= 1.18-0" .Capabilities.KubeVersion.Version)) -}}
{{- end -}}

{{/*
Return if ingress supports pathType.
*/}}
{{- define "ingress.supportsPathType" -}}
  {{- or (eq (include "ingress.isStable" .) "true") (and (eq (include "ingress.apiVersion" .) "networking.k8s.io/v1beta1") (semverCompare ">= 1.18-0" .Capabilities.KubeVersion.Version)) -}}
{{- end -}}

{{/*
 Generate config map data
 */}}
{{- define "grafana.configData" -}}
grafana.ini: |
{{- range $elem, $elemVal := index .Values.grafana "config" }}
  {{- if not (kindIs "map" $elemVal) }}
  {{- if kindIs "invalid" $elemVal }}
  {{ $elem }} =
  {{- else if kindIs "slice" $elemVal }}
  {{ $elem }} = {{ toJson $elemVal }}
  {{- else if kindIs "string" $elemVal }}
  {{ $elem }} = {{ tpl $elemVal $ }}
  {{- else }}
  {{ $elem }} = {{ $elemVal }}
  {{- end }}
  {{- end }}
{{- end }}
{{- range $key, $value := index .Values.grafana "config" }}
  {{- if kindIs "map" $value }}
  [{{ $key }}]
  {{- range $elem, $elemVal := $value }}
  {{- if kindIs "invalid" $elemVal }}
  {{ $elem }} =
  {{- else if kindIs "slice" $elemVal }}
  {{ $elem }} = {{ toJson $elemVal }}
  {{- else if kindIs "string" $elemVal }}
  {{ $elem }} = {{ tpl $elemVal $ }}
  {{- else }}
  {{ $elem }} = {{ $elemVal }}
  {{- end }}
  {{- end }}
  {{- end }}
{{- end }}
{{- end }}