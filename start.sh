#!/bin/bash

set -e  # Exit on error
trap "echo '❌ Script failed. Check logs above.'" ERR

echo "🚀 Starting Minikube and setting Docker env..."
minikube start
eval $(minikube docker-env)

echo "📦 Building Docker images..."
docker build -t authentication-service:latest ./authentication-service
docker build -t field-service:latest ./field-service

echo "📁 Applying Kubernetes configs..."
kubectl apply -f k8s/

echo "⏳ Waiting for deployments to become ready..."
kubectl wait --for=condition=available --timeout=90s deployment/authentication-service
kubectl wait --for=condition=available --timeout=90s deployment/field-service

echo "🔌 Starting tunnel in background (leave terminal open)..."
minikube tunnel &
sleep 5  # Give it time to set up the tunnel

echo "🌐 Getting service URLs..."
AUTH_URL=$(minikube service authentication-service --url)
FIELD_URL=$(minikube service field-service --url)

echo "🔐 Authentication Service available at: $AUTH_URL"
echo "📍 Field Service available at:        $FIELD_URL"

echo "✅ All services are running!"
echo "📣 NOTE: Leave this terminal open to keep the tunnel alive."
