django
======
This Chart is to deploy an extendible architecture of a Django application over K8s using only wsgi container.

Current chart version is `0.11.7`

## Doc generation

Code formatting and documentation for variables is generated using [helm-doc](https://github.com/norwoodj/helm-docs).

Install `helm-docs` with `go get github.com/norwoodj/helm-docs` or `brew install helm-docs`.

## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| api.affinity | string | `nil` |  |
| api.autoscaling.enabled | bool | `false` |  |
| api.autoscaling.maxReplicas | int | `11` |  |
| api.autoscaling.minReplicas | int | `2` |  |
| api.autoscaling.targetCPUUtilizationPercentage | int | `50` |  |
| api.autoscaling.targetMemoryUtilizationPercentage | int | `50` |  |
| api.command | string | `nil` |  |
| api.commandPath | string | `"config.wsgi:application"` |  |
| api.dev.enabled | bool | `true` |  |
| api.enabled | bool | `true` |  |
| api.externalSecrets.enabled | bool | `false` |  |
| api.extraEnvironmentVars | object | `{}` |  |
| api.extraSecretEnvironmentVars | list | `[]` |  |
| api.ingress.annotations | string | `"http.port: \"80\"\nkubernetes.io/ingress.class: \"nginx-public\"\nnginx.ingress.kubernetes.io/client-body-buffer-size: \"75m\"\nnginx.ingress.kubernetes.io/proxy-body-size: \"50m\"\nnginx.ingress.kubernetes.io/proxy-send-timeout: \"30\"\nnginx.ingress.kubernetes.io/proxy-read-timeout: \"30\"\nkubernetes.io/tls-acme: \"true\"\nnginx.ingress.kubernetes.io/ssl-redirect: \"true\"\n"` |  |
| api.ingress.enabled | bool | `false` |  |
| api.ingress.hosts[0].host | string | `"api.moni.com.ar"` |  |
| api.ingress.hosts[0].paths[0] | object | `path: "/"` |  |
| api.ingress.hosts[0].paths[1] | object | `path: "/api/v3/prepaid_card/validate_address" \n serviceName: "api-gire"` |  |
| api.ingress.labels | object | `{}` |  |
| api.ingress.tls.hosts[0] | string | `"api.moni.com.ar"` |  |
| api.livenessProbe.enabled | bool | `false` |  |
| api.livenessProbe.initialDelaySeconds | int | `60` |  |
| api.livenessProbe.path | string | `"/v1/sys/health?standbyok=true"` |  |
| api.nodeSelector | object | `{}` |  |
| api.readinessProbe.enabled | bool | `true` |  |
| api.replicaCount | int | `1` |  |
| api.resources | object | `{}` |  |
| api.service.annotations | object | `{}` |  |
| api.service.enabled | bool | `false` |  |
| api.service.healthcheck.enabled | bool | `false` |  |
| api.service.healthcheck.livenessProbe.enabled | bool | `true` |  |
| api.service.healthcheck.livenessProbe.path | string | `"/health/ready"` |  |
| api.service.healthcheck.readinessProbe.enabled | bool | `true` |  |
| api.service.healthcheck.readinessProbe.path | string | `nil` |  |
| api.service.port | int | `8000` |  |
| api.service.targetPort | int | `8200` |  |
| api.terminationGracePeriodSeconds | int | `300` |  |
| api.tolerations | string | `nil` |  |
| api.varsSecretName | string | `""` |  |
|