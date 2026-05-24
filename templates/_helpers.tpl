{{/*
Expand the chart name.
*/}}
{{- define "besu-marketplace.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create fully qualified app name.
*/}}
{{- define "besu-marketplace.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s" $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Common Labels
*/}}
{{- define "besu-marketplace.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/name: {{ include "besu-marketplace.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector Labels
*/}}
{{- define "besu-marketplace.selectorLabels" -}}
app.kubernetes.io/name: {{ include "besu-marketplace.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
RPC Labels
*/}}
{{- define "besu.rpcLabels" -}}
{{ include "besu-marketplace.labels" . }}
app.kubernetes.io/component: rpc
{{- end }}

{{/*
Validator Labels
*/}}
{{- define "besu.validatorLabels" -}}
{{ include "besu-marketplace.labels" . }}
app.kubernetes.io/component: validator
{{- end }}

{{/*
Bootnode Labels
*/}}
{{- define "besu.bootnodeLabels" -}}
{{ include "besu-marketplace.labels" . }}
app.kubernetes.io/component: bootnode
{{- end }}

{{/*
Prometheus annotations
*/}}
{{- define "besu.prometheusAnnotations" -}}
prometheus.io/scrape: "true"
prometheus.io/port: "9545"
{{- end }}

{{/*
Config checksum
Triggers rolling restart on configmap update
*/}}
{{- define "besu.configChecksum" -}}
{{ include (print $.Template.BasePath "/configmap.yaml") . | sha256sum }}
{{- end }}

{{/*
Storage class helper
*/}}
{{- define "besu.storageClass" -}}
{{- if .Values.storage.className }}
{{ .Values.storage.className }}
{{- else }}
gp3
{{- end }}
{{- end }}

{{/*
Image helper
*/}}
{{- define "besu.image" -}}
{{ .Values.image.repository }}:{{ .Values.image.tag }}
{{- end }}

{{/*
Service Account Name
*/}}
{{- define "besu-marketplace.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "besu-marketplace.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Validator selector labels
*/}}
{{- define "besu.validatorSelectorLabels" -}}
app.kubernetes.io/component: validator
{{- end }}

{{/*
RPC selector labels
*/}}
{{- define "besu.rpcSelectorLabels" -}}
app.kubernetes.io/component: rpc
{{- end }}

{{/*
Bootnode selector labels
*/}}
{{- define "besu.bootnodeSelectorLabels" -}}
app.kubernetes.io/component: bootnode
{{- end }}