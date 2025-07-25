#!/bin/bash

echo "Deleting Kubernetes resources..."
kubectl delete -f k8s/

echo "Stopping Minikube..."
minikube stop

echo "Killing background port-forward processes (if any)..."
pkill -f "kubectl port-forward" || echo "⚠️ No port-forward process found."

echo "Killing Minikube tunnel (if running)..."
pkill -f "minikube tunnel" || echo "⚠️ No tunnel process found."

echo "✅ Clean shutdown complete."
