# GOIT ARGO — GitOps Deployment with ArgoCD + AWS EKS

You should already have:
- An EKS cluster created (from Homework 5–6)

## 1. Create your git-repo with Helm-deployment
my repo 
https://github.com/Serhii-Khodyka/goit-argo.git

## 2. Add Git repository and check IP and S3
file variables.tf
app_repo_url https://github.com/Serhii-Khodyka/goit-argo.git
eks_state_bucket  serhii-my-tf-state-bucket
backend.tf s3-bucket serhii-my-tf-state-bucket

## 3. Deploy ArgoCD via Terraform
cd terraform/argocd
terraform init
terraform apply -auto-approve

## 4. Verify Deployment
kubectl get pods -n application

## 5. Access ArgoCD UI
kubectl port-forward svc/argocd-server -n agrocd 8080:80

http://localhost:8080

kubectl -n agrocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

or for Windows
kubectl -n agrocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" > enc.txt
certutil -decode enc.txt dec.txt
type dec.txt

Login:
username: admin
password: from the link above

## 6. ArgoCD Application Configuration

ArgoCD automatically uses the file:
applications/nginx-app.yaml
from your https://github.com/Serhii-Khodyka/goit-argo.git
This file defines a GitOps deployment for the Helm chart.

Once pushed to GitHub, ArgoCD will automatically:
detect changes
render the Helm chart
apply changes to the cluster
keep resources in Sync

## 7. Check ArgoCD Applications
kubectl get applications -n argocd

Expected return 
nginx-app   Synced   Healthy

## Recommendations. Deleting after working
terraform destroy -auto-approve
