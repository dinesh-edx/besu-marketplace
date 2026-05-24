{{/*
Expand the name of the chart.
*/}}
{{- define "besu.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "besu.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Chart name and version.
*/}}
{{- define "besu.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" }}
{{- end }}

{{/*
Common labels.
*/}}
{{- define "besu.labels" -}}
helm.sh/chart: {{ include "besu.chart" . }}
app.kubernetes.io/name: {{ include "besu.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels.
*/}}
{{- define "besu.selectorLabels" -}}
app.kubernetes.io/name: {{ include "besu.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Validator labels.
*/}}
{{- define "besu.validatorLabels" -}}
{{ include "besu.labels" . }}
app.kubernetes.io/component: validator
{{- end }}

{{/*
RPC labels.
*/}}
{{- define "besu.rpcLabels" -}}
{{ include "besu.labels" . }}
app.kubernetes.io/component: rpc
{{- end }}

{{/*
Bootnode labels.
*/}}
{{- define "besu.bootnodeLabels" -}}
{{ include "besu.labels" . }}
app.kubernetes.io/component: bootnode
{{- end }}

{{/*
Prometheus annotations.
*/}}
{{- define "besu.prometheusAnnotations" -}}
prometheus.io/scrape: "true"
prometheus.io/port: "9545"
{{- end }}

{{/*
Storage class helper.
*/}}
{{- define "besu.storageClass" -}}
{{- if .Values.storage.className }}
{{- .Values.storage.className }}
{{- else }}
gp3
{{- end }}
{{- end }}

{{/*
Image helper.
*/}}
{{- define "besu.image" -}}
{{ .Values.image.repository }}:{{ .Values.image.tag }}
{{- end }}

{{/*
ServiceAccount name.
*/}}
{{- define "besu.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "besu.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Config checksum helper.
*/}}
{{- define "besu.configChecksum" -}}
{{ include (print $.Template.BasePath "/configmap.yaml") . | sha256sum }}
{{- end }}