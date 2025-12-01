# GOIT ARGO — GitOps Deployment with ArgoCD + AWS EKS

## 1. Deploy ArgoCD via Terraform
cd terraform/argocd
terraform init
terraform apply -auto-approve

kubectl get pods -n infra-tools

## 2. Access ArgoCD UI
kubectl port-forward svc/argocd-server -n infra-tools 8080:80

http://localhost:8080

kubectl -n infra-tools get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
або для Windows
kubectl -n infra-tools get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" > enc.txt
certutil -decode enc.txt dec.txt
type dec.txt

Логін:

username: admin
password: з команди вище

## 3. Add Git repository
argocd repo add https://github.com/YOUR-USER/goit-argo --insecure-skip-server-verification

## 4. Verify Deployment
kubectl get pods -n application

## 5. Deleting after working
terraform destroy -auto-approve
