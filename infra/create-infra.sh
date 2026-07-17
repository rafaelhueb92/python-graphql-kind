#! /bin/bash
set -e 

echo ""
echo "======================================"
echo "Creating Kind Cluster..."
echo "======================================"

kind create cluster -n graphql-app

echo ""
echo "======================================"
echo "Adding Helm repositories..."
echo "======================================"

helm repo add argocd https://argoproj.github.io/argo-helm

echo ""
echo "======================================"
echo "Installing ArgoCD..."
echo "======================================"
helm upgrade --install argocd argocd/argo-cd \
  --namespace argocd \
  -f infra/argocd-values.yaml \
  --create-namespace \
  --wait

echo "Creating file secret-argo.txt with ArgoCD initial admin password..."
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d > secret-argo.txt

echo ""
echo "======================================"
echo "Building Docker images..."
echo "======================================"

docker build -t graphql-app-py:v1.0 ./app/.


echo ""
echo "======================================"
echo "Adding Image into the Kind repositories..."
echo "======================================"

kind load -n graphql-app docker-image graphql-py:latest

echo ""
echo "======================================"
echo "Adding Argo App..."
echo "======================================"

kubectl apply -f infra/argo-app.yaml

echo ""
echo "======================================"
echo "Port Forwarding App..."
echo "======================================"
echo "You can access the app at http://localhost:8080"
echo "======================================"
echo "If got error of not exist, run the command below to create the port forward:"
echo "kubectl port-forward svc/dep-graphql-pyp 8080:8080"
echo "======================================"

kubectl port-forward svc/dep-graphql-pyp 8080:8080