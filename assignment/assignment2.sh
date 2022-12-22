#!/bin/bash

minikube start
minikube status
# minikube dashboard (if we want to check with Kubernetes Dashboard UI)

sleep 50


## For Mysql StatefulSet, Persistent Volume, Persistent Volume Cliam, Secret, Service & Configmap
kubectl create -f mysql-server.yaml


## Prometheus Install and Setup 
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack
kubectl expose service prometheus-operated  --type=NodePort --target-port=9090 --name=prometheus-server
minikube service list
## To Access Dashboard From Minikube ## Option 1
minikube service prometheus-server


## Grafana Dashboard ## Option 1
minikube service list
kubectl expose service grafana --type=NodePort --target-port=3000 --name=grafana
kubectl get secret --namespace default prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
minikube service list
minikube service grafana

## To Access Dashboard From Minikube ## Option 1
## Access Prometheus Dashboard
$ kubectl port-forward prometheus-prom-kube-prometheus-stack-prometheus-name 9090

## Grafana Dashboard ## Option 1
## Access Grafana Dashboard
$ kubectl port-forward prom-grafana-name 3000