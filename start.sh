#!/bin/bash

set -e  # Exit on error
trap "echo 'Script failed. Check logs above.'" ERR

echo "Checking Docker status..."

# Check if Docker is running
if ! docker system info > /dev/null 2>&1; then
  echo "Docker is not running. Attempting to start Docker Desktop..."

  # Open Docker Desktop (Mac only)
  open -a Docker

  echo "Waiting for Docker to start..."
  while ! docker system info > /dev/null 2>&1; do
    sleep 2
  done

  echo "Docker is now running!"
else
  echo "Docker is already running!"
fi

echo "Starting Minikube and setting Docker env..."
minikube start
eval $(minikube docker-env)

echo "Building Docker images..."
docker build -t authentication-service:latest ./authentication-service
docker build -t field-service:latest ./field-service

echo "applying Kubernetes configs..."
kubectl apply -f k8s/

echo "Waiting for deployments to become ready..."
kubectl wait --for=condition=available --timeout=90s deployment/authentication-service
kubectl wait --for=condition=available --timeout=90s deployment/field-service

echo "🔌 Starting port-forwarding in background..."

# Kill existing port-forwards (if any)
pkill -f "kubectl port-forward service/authentication-service" || true
pkill -f "kubectl port-forward service/field-service" || true

# Start port-forwarding in background
kubectl port-forward service/authentication-service 30081:8080 > /dev/null 2>&1 &
kubectl port-forward service/field-service 30082:8081 > /dev/null 2>&1 &

sleep 2  # Give port-forwarding a moment to start

echo "Authentication Service available at: http://127.0.0.1:30081"
echo "Field Service available at: http://127.0.0.1:30082"

# Optional: update frontend/.env file field http://localhost:30082 auth http://localhost:30081
echo "AUTH_URL=http://127.0.0.1:30081" > frontend/.env
echo "FIELD_URL=http://127.0.0.1:30082" >> frontend/.env

echo "✅ All services are running and forwarded to localhost!"
echo "Use these URLs in Flutter when using iOS Simulator."
