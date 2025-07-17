#!/bin/bash

echo "Deleting K8s resources..."
kubectl delete -f k8s/

echo "Stopping Minikube..."
minikube stop

echo "Killing tunnel (if any)..."
pkill -f "minikube tunnel" || true

echo "✅ Clean shutdown complete."
