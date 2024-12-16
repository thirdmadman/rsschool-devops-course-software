#!/bin/bash
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

ADMIN_PASSWORD="${GRAFANA_ADMIN_PASSWORD:-$(openssl rand -base64 8)}"
SMTP_HOST="${GRAFANA_SMTP_HOST:-'email-smtp.eu-north-1.amazonaws.com:587'}"
SMTP_USER="${GRAFANA_SMTP_USER:-'USER'}"
SMTP_PASSWORD="${GRAFANA_SMTP_PASSWORD:-'PASSWORD'}"
SMTP_FROM_ADDRESS="${GRAFANA_SMTP_FROM_ADDRESS:-'someone@example.com'}"

kubectl create secret generic grafana-admin-secret -n monitoring --from-literal=admin-password="$ADMIN_PASSWORD"

kubectl create configmap grafana-dashboard -n monitoring --from-file=/root/grafana/grafana-dashboard.json

kubectl create configmap grafana-alert-rules -n monitoring --from-file=alert-rules.yaml

helm upgrade --install grafana bitnami/grafana -n monitoring \
--set service.type="NodePort" \
--set service.nodePorts.grafana="32030" \
--set-json 'datasources.secretDefinition={"apiVersion":1,"datasources":[{"name":"Prometheus","type":"prometheus","url":"http://prometheus-kube-prometheus-prometheus:9090","isDefault":true,"uid":"prometheusdatasource"}]}' \
--set dashboardsProvider.enabled=true \
--set dashboardsConfigMaps[0].configMapName=grafana-dashboard \
--set dashboardsConfigMaps[0].fileName=grafana-dashboard.json \
--set admin.existingSecret="grafana-admin-secret" \
--set admin.existingSecretPasswordKey="admin-password" \
--set smtp.enabled=true \
--set smtp.user="$SMTP_USER" \
--set smtp.password="$SMTP_PASSWORD" \
--set smtp.host="$SMTP_HOST" \
--set smtp.fromAddress="$SMTP_FROM_ADDRESS" \
--set smtp.fromName="Grafana Alert" \
--set smtp.skipVerify="true" \
--set alerting.configMapName="grafana-alert-rules"