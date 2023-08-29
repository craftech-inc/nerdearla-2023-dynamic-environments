#######################################################
###############        GENERAL       ##################
#######################################################

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to
this (by the DNS naming spec). If release name contains chart name it will
be used as a full name.
*/}}
{{- define "django.fullname" -}}
{{- if ne (.Values.global.projectName | toString) "" -}}
{{- .Values.global.projectName | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "django.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "django.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

#######################################################
###############         API          ##################
#######################################################


{{/*
Set's the replica count based on the different modes configured by user
*/}}
{{- define "api.replicas" -}}
  {{ if eq .mode "ha" }}
    {{- .Values.api.ha.replicas | default 3 -}}
  {{ else }}
    {{- default 1 -}}
  {{ end }}
{{- end -}}

{{/*
Inject extra environment vars in the format key:value, if populated
*/}}
{{- define "api.extraEnvironmentVars" -}}
{{- if .extraEnvironmentVars -}}
{{- range $key, $value := .extraEnvironmentVars }}
- name: {{ printf "%s" $key | replace "." "_" | upper | quote }}
  value: {{ $value | quote }}
{{- end }}
{{- end -}}
{{- end -}}
{{/*
Inject extra environment populated by secrets, if populated
*/}}
{{- define "api.extraSecretEnvironmentVars" -}}
{{- if .extraSecretEnvironmentVars -}}
{{- range .extraSecretEnvironmentVars }}
- name: {{ .envName }}
  valueFrom:
   secretKeyRef:
     name: {{ .secretName }}
     key: {{ .secretKey }}
{{- end -}}
{{- end -}}
{{- end -}}


{{/*
Set's the node selector for pod placement when running in standalone and HA modes.
*/}}
{{- define "api.nodeselector" -}}
{{- if .Values.api.nodeSelector -}}
  nodeSelector: {{ toYaml .Values.api.nodeSelector | nindent 8 }}
{{ end }}
{{- end -}}


{{/*
Set's the affinity for pod placement when running in standalone and HA modes.
*/}}
{{- define "api.affinity" -}}
{{- end -}}

{{/*
Sets the api toleration for pod placement
*/}}
{{- define "api.tolerations" -}}
  {{- if .Values.api.tolerations }}
      tolerations:
        {{ tpl .Values.api.tolerations . | nindent 8 | trim }}
  {{- end }}
{{- end -}}

{{/*
Sets extra ingress annotations
*/}}
{{- define "api.ingress.annotations" -}}
  {{- if .Values.api.ingress.annotations }}
  annotations:
    {{- tpl .Values.api.ingress.annotations . | nindent 4 }}
  {{- end }}
{{- end -}}

{{/*
Set's the container resources if the user has set any.
*/}}
{{- define "api.resources" -}}
  {{- if .Values.api.resources -}}
          resources:
{{ toYaml .Values.api.resources | indent 12}}
  {{ else }}
  {{ end }}
{{- end -}}


{{/*
Set's up configmap mounts if this isn't a dev deployment and the user
defined a custom configuration.  Additionally iterates over any
extra volumes the user may have specified (such as a secret with TLS).
*/}}
{{- define "api.volumes" -}}
  {{ if .Values.api.extraVolumes }}
      volumes:
    {{- range .Values.api.extraVolumes }}
      - name: {{ .name }}
        {{ .type }}:
        {{- if (eq .type "configMap") }}
          name: {{ .name }}
        {{- else if (eq .type "secret") }}
          secretName: {{ .name }}
        {{- end }}
    {{- end }}
  {{ end }}
{{- end -}}

{{/*
Set's which additional volumes should be mounted to the container
based on the mode configured.
*/}}
{{- define "api.mounts" -}}
  {{ if .Values.api.extraVolumes }}
          volumeMounts:
    {{- range .Values.api.extraVolumes }}
          - name: {{ .name }}
            readOnly: true
            mountPath: {{ .path | default "/mnt" }}
    {{- end }}
  {{- end }}
{{- end -}}

{{/*
Set's the container resources if the user has set any.
*/}}
{{- define "api.hostAliases" -}}
  {{- if .Values.api.hostAliases -}}
      hostAliases:
    {{- tpl .Values.api.hostAliases . | nindent 6 }}
  {{ else }}
  {{ end }}
{{- end -}}


#######################################################
##############      BACKOFFICE          ###############
#######################################################

{{/*
Inject extra environment vars in the format key:value, if populated
*/}}
{{- define "backoffice.extraEnvironmentVars" -}}
{{- if .extraEnvironmentVars -}}
{{- range $key, $value := .extraEnvironmentVars }}
- name: {{ printf "%s" $key | replace "." "_" | upper | quote }}
  value: {{ $value | quote }}
{{- end }}
{{- end -}}
{{- end -}}
{{/*
Inject extra environment populated by secrets, if populated
*/}}
{{- define "backoffice.extraSecretEnvironmentVars" -}}
{{- if .extraSecretEnvironmentVars -}}
{{- range .extraSecretEnvironmentVars }}
- name: {{ .envName }}
  valueFrom:
   secretKeyRef:
     name: {{ .secretName }}
     key: {{ .secretKey }}
{{- end -}}
{{- end -}}
{{- end -}}


{{/*
Set's the node selector for pod placement when running in standalone and HA modes.
*/}}
{{- define "backoffice.nodeselector" -}}
{{- if .Values.backoffice.nodeSelector -}}
  nodeSelector: {{ toYaml .Values.backoffice.nodeSelector | nindent 8 }}
{{ end }}
{{- end -}}


{{/*
Set's the affinity for pod placement when running in standalone and HA modes.
*/}}
{{- define "backoffice.affinity" -}}
{{- end -}}

{{/*
Sets the api toleration for pod placement
*/}}
{{- define "backoffice.tolerations" -}}
  {{- if .Values.backoffice.tolerations }}
      tolerations:
        {{ tpl .Values.backoffice.tolerations . | nindent 8 | trim }}
  {{- end }}
{{- end -}}


{{/*
Sets extra ingress annotations
*/}}
{{- define "backoffice.ingress.annotations" -}}
  {{- if .Values.backoffice.ingress.annotations }}
  annotations:
    {{- tpl .Values.backoffice.ingress.annotations . | nindent 4 }}
  {{- end }}
{{- end -}}
{{/*
Set's the container resources if the user has set any.
*/}}
{{- define "backoffice.resources" -}}
  {{- if .Values.backoffice.resources -}}
          resources:
{{ toYaml .Values.backoffice.resources | indent 12}}
  {{ else }}
  {{ end }}
{{- end -}}


{{/*
Set's up configmap mounts if this isn't a dev deployment and the user
defined a custom configuration.  Additionally iterates over any
extra volumes the user may have specified (such as a secret with TLS).
*/}}
{{- define "backoffice.volumes" -}}
  {{ if .Values.backoffice.extraVolumes }}
      volumes:
    {{- range .Values.backoffice.extraVolumes }}
      - name: {{ .name }}
        {{ .type }}:
        {{- if (eq .type "configMap") }}
          name: {{ .name }}
        {{- else if (eq .type "secret") }}
          secretName: {{ .name }}
        {{- end }}
    {{- end }}
  {{ end }}
{{- end -}}

{{/*
Set's which additional volumes should be mounted to the container
based on the mode configured.
*/}}
{{- define "backoffice.mounts" -}}
  {{ if .Values.backoffice.extraVolumes }}
          volumeMounts:
    {{- range .Values.backoffice.extraVolumes }}
          - name: {{ .name }}
            readOnly: true
            mountPath: {{ .path | default "/mnt" }}
    {{- end }}
  {{- end }}
{{- end -}}

{{/*
Set's the container resources if the user has set any.
*/}}
{{- define "backoffice.hostAliases" -}}
  {{- if .Values.backoffice.hostAliases -}}
      hostAliases:
    {{- tpl .Values.backoffice.hostAliases . | nindent 6 }}
  {{ else }}
  {{ end }}
{{- end -}}


#######################################################
###############       INTERNAL       ##################
#######################################################

{{/*
Inject extra environment vars in the format key:value, if populated
*/}}
{{- define "internal.extraEnvironmentVars" -}}
{{- if .extraEnvironmentVars -}}
{{- range $key, $value := .extraEnvironmentVars }}
- name: {{ printf "%s" $key | replace "." "_" | upper | quote }}
  value: {{ $value | quote }}
{{- end }}
{{- end -}}
{{- end -}}
{{/*
Inject extra environment populated by secrets, if populated
*/}}
{{- define "internal.extraSecretEnvironmentVars" -}}
{{- if .extraSecretEnvironmentVars -}}
{{- range .extraSecretEnvironmentVars }}
- name: {{ .envName }}
  valueFrom:
   secretKeyRef:
     name: {{ .secretName }}
     key: {{ .secretKey }}
{{- end -}}
{{- end -}}
{{- end -}}


{{/*
Set's the node selector for pod placement when running in standalone and HA modes.
*/}}
{{- define "internal.nodeselector" -}}
{{- if .Values.internal.nodeSelector -}}
  nodeSelector: {{ toYaml .Values.backoffice.nodeSelector | nindent 8 }}
{{ end }}
{{- end -}}


{{/*
Set's the affinity for pod placement when running in standalone and HA modes.
*/}}
{{- define "internal.affinity" -}}
{{- end -}}

{{/*
Sets the api toleration for pod placement
*/}}
{{- define "internal.tolerations" -}}
  {{- if .Values.internal.tolerations }}
      tolerations:
        {{ tpl .Values.internal.tolerations . | nindent 8 | trim }}
  {{- end }}
{{- end -}}


{{/*
Sets extra ingress annotations
*/}}
{{- define "internal.ingress.annotations" -}}
  {{- if .Values.internal.ingress.annotations }}
  annotations:
    {{- tpl .Values.internal.ingress.annotations . | nindent 4 }}
  {{- end }}
{{- end -}}
{{/*
Set's the container resources if the user has set any.
*/}}
{{- define "internal.resources" -}}
  {{- if .Values.internal.resources -}}
          resources:
{{ toYaml .Values.internal.resources | indent 12}}
  {{ else }}
  {{ end }}
{{- end -}}


{{/*
Set's up configmap mounts if this isn't a dev deployment and the user
defined a custom configuration.  Additionally iterates over any
extra volumes the user may have specified (such as a secret with TLS).
*/}}
{{- define "internal.volumes" -}}
  {{ if .Values.internal.extraVolumes }}
      volumes:
    {{- range .Values.internal.extraVolumes }}
      - name: {{ .name }}
        {{ .type }}:
        {{- if (eq .type "configMap") }}
          name: {{ .name }}
        {{- else if (eq .type "secret") }}
          secretName: {{ .name }}
        {{- end }}
    {{- end }}
  {{ end }}
{{- end -}}

{{/*
Set's which additional volumes should be mounted to the container
based on the mode configured.
*/}}
{{- define "internal.mounts" -}}
  {{ if .Values.internal.extraVolumes }}
          volumeMounts:
    {{- range .Values.internal.extraVolumes }}
          - name: {{ .name }}
            readOnly: true
            mountPath: {{ .path | default "/mnt" }}
    {{- end }}
  {{- end }}
{{- end -}}

{{/*
Set's the container resources if the user has set any.
*/}}
{{- define "internal.hostAliases" -}}
  {{- if .Values.internal.hostAliases -}}
      hostAliases:
    {{- tpl .Values.internal.hostAliases . | nindent 6 }}
  {{ else }}
  {{ end }}
{{- end -}}


#######################################################
###############        JOBS          ##################
#######################################################

{{/*
Set's the node selector for pod placement when running in standalone and HA modes.
*/}}
{{- define "jobs.nodeselector" -}}
{{- end -}}


{{/*
Set's the affinity for pod placement when running in standalone and HA modes.
*/}}
{{- define "jobs.affinity" -}}
{{- end -}}

{{/*
Sets the jobs toleration for pod placement
*/}}
{{- define "jobs.tolerations" -}}
  {{- if .job.tolerations -}}
      tolerations:
      {{- range (.job.tolerations | default (list "/")) }}
      - key: {{ .key }}
        {{ if .operator -}}
        operator: {{ .operator }}
        {{- end }} 
        {{ if .value -}}
        value: {{ .value }}
        {{- end }} 
        {{ if .effect -}}
        effect: {{ .effect }}
        {{- end }} 
      {{- end }}
  {{ else if .Values.jobs.tolerations }}
      tolerations:
      {{- range (.Values.jobs.tolerations | default (list "/")) }}
      - key: {{ .key }}
        {{ if .operator -}}
        operator: {{ .operator }}
        {{- end }} 
        {{ if .value -}}
        value: {{ .value }}
        {{- end }} 
        {{ if .effect -}}
        effect: {{ .effect }}
        {{- end }} 
      {{- end }}
  {{- else -}}

  {{- end -}}
{{- end -}}


{{/*
Set's the container resources if the user has set any.
*/}}
{{- define "jobs.resources" -}}
  {{ if .job.resources }}
        resources:
{{ toYaml .job.resources | indent 10}}
  {{ else }}
        resources:
{{ toYaml .Values.jobs.resources | indent 10}}
  {{ end }}
{{- end -}}

{{- define "django.job" -}}
{{- if .job.enabled -}}
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ template "django.fullname" . }}-{{ .job.name }}
  {{- if .job.annotations }}
  annotations:
{{ toYaml .job.annotations | indent 4 }}
  {{- end }}
spec:
  backoffLimit: {{ .job.backoffLimit }}
  activeDeadlineSeconds: {{ .job.activeDeadlineSeconds }}
  template:
    spec:
      {{ template "jobs.affinity" . }}
      {{ template "jobs.tolerations" . }}
      {{ template "jobs.nodeselector" . }}
      containers:
      - name: {{ .job.containerName | quote }}
        image: {{ .Values.global.image.repository }}:{{ .Values.global.image.tag }}
        {{ if .job.args }}
        command: [ "python", "manage.py", {{ .job.command | quote }}, {{ .job.args | quote }}, {{ .job.settings | quote }}]
        {{ else }}
        command: [ "python", "manage.py", {{ .job.command | quote }}, {{ .job.settings | quote }}]
        {{ end }}
        {{ template "jobs.resources" . }}
        envFrom:
        - secretRef:
        {{- if .Values.global.externalSecrets.enabled }}
            name: {{ .Values.global.projectName }}-api
        {{ else }}
            name: {{ .Values.api.varsSecretName | default "null" | quote }}
        {{- end }}
      restartPolicy: {{ .job.restartPolicy | quote }}
---
{{- end -}}
{{- end -}}

#######################################################
###############       CRONJOBS          ###############
#######################################################

{{/*
Set's the node selector for pod placement when running in standalone and HA modes.
*/}}
{{- define "cronjobs.nodeselector" -}}
{{- end -}}


{{/*
Set's the affinity for pod placement when running in standalone and HA modes.
*/}}
{{- define "cronjobs.affinity" -}}
{{- end -}}
{{/*
Sets the cronjobs toleration for pod placement
*/}}
{{- define "cronjobs.tolerations" -}}
  {{- if .cronjob.tolerations -}}
          tolerations:
          {{- range (.cronjob.tolerations | default (list "/")) }}
      - key: {{ .key }}
        {{ if .operator -}}
        operator: {{ .operator }}
        {{- end }} 
        {{ if .value -}}
        value: {{ .value }}
        {{- end }} 
        {{ if .effect -}}
        effect: {{ .effect }}
        {{- end }} 
          {{- end }}
  {{ else if .Values.cronjobs.tolerations }}
          tolerations:
          {{- range (.Values.cronjobs.tolerations | default (list "/")) }}
      - key: {{ .key }}
        {{ if .operator -}}
        operator: {{ .operator }}
        {{- end }} 
        {{ if .value -}}
        value: {{ .value }}
        {{- end }} 
        {{ if .effect -}}
        effect: {{ .effect }}
        {{- end }} 
          {{- end }}
  {{- else -}}
  {{- end -}}
{{- end -}}

{{/*
Set's the container resources if the user has set any.
*/}}
{{- define "cronjob.resources" -}}
  {{ if .cronjob.resources }}
            resources:
{{ toYaml .cronjob.resources | indent 14}}
  {{ else }}
            resources:
{{ toYaml .Values.cronjobs.resources | indent 14}}
  {{ end }}
{{- end -}}

{{- define "django.cronjob" -}}
{{- if .cronjob.enabled -}}

apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: {{ .cronjob.name | quote }}
  namespace: {{ .Values.global.namespace }}-cronjobs
spec:
  {{- if .cronjob.suspend }}
  suspend: {{ .cronjob.suspend -}}
  {{- end }}
  schedule: {{ .cronjob.schedule | quote }}
  {{ if .cronjob.concurrencyPolicy }}
  concurrencyPolicy: {{ .cronjob.concurrencyPolicy | quote }}
  {{ else }}
  concurrencyPolicy: {{ .Values.cronjobs.concurrencyPolicy | quote }}
  {{ end }}
  jobTemplate:
    spec:
      backoffLimit: {{ .cronjob.backoffLimit }}
      template:
        spec:
      {{ template "cronjobs.affinity" . }}
      {{ template "cronjobs.tolerations" . }}
      {{ template "cronjobs.nodeselector" . }}
          restartPolicy: {{ .cronjob.restartPolicy | quote }}
          containers:
          - name: {{ .cronjob.containerName | quote }}
            image: {{ .Values.global.image.repository }}:{{ .Values.global.image.tag }}
            {{ if .cronjob.args }}
            command: [ "python", "manage.py", {{ .cronjob.command | quote }}, {{ .cronjob.args | quote }}, {{ .cronjob.settings | quote }}]
            {{ else }}
            command: [ "python", "manage.py", {{ .cronjob.command | quote }}, {{ .cronjob.settings | quote }}]
            {{ end }}     
        {{ template "cronjob.resources" . }}
            envFrom:
            - secretRef:
            {{- if .Values.cronjobs.varsSecretName }}
                name: {{ .Values.cronjobs.varsSecretName }}
            {{- else if .Values.global.externalSecrets.enabled }}
                name: {{ .Values.global.projectName }}-api
            {{ else }}
                name: {{ .Values.api.varsSecretName | default "null" | quote }}
            {{- end }}
---
{{- end -}}
{{- end -}}
