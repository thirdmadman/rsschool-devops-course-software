#!/bin/bash
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

kubectl create secret generic grafana-admin-secret -n monitoring --from-literal=admin-password=$(openssl rand -base64 8)

kubectl create configmap grafana-dashboard -n monitoring --from-file=/root/grafana/grafana-dashboard.json

helm upgrade --install grafana bitnami/grafana -n monitoring \
--set service.type="NodePort" \
--set service.nodePorts.grafana="32030" \
--set-json 'datasources.secretDefinition={"apiVersion":1,"datasources":[{"name":"Prometheus","type":"prometheus","url":"http://prometheus-kube-prometheus-prometheus:9090","isDefault":true,"uid":"prometheusdatasource"}]}' \
--set dashboardsProvider.enabled=true \
--set dashboardsConfigMaps[0].configMapName=grafana-dashboard \
--set dashboardsConfigMaps[0].fileName=grafana-dashboard.json \
--set admin.existingSecret: "grafana-admin-secret" \
--set admin.existingSecretPasswordKey: admin-password
