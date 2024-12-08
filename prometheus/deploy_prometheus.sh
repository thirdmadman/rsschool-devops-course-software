#!/bin/bash
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

kubectl create ns monitoring

kubectl get svc --all-namespaces

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

echo 'helm list --all-namespaces' && helm list --all-namespaces

helm upgrade --install -n monitoring prometheus bitnami/kube-prometheus --set prometheus.service.type=NodePort --set prometheus.service.nodePorts.http=32090

echo 'helm list --all-namespaces' && helm list --all-namespaces
echo 'kubectl get svc --all-namespaces' && kubectl get svc --all-namespaces
echo 'kubectl get pods -o wide --all-namespaces' && kubectl get pods -o wide --all-namespaces