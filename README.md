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

or for Windows
kubectl -n infra-tools get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" > enc.txt
certutil -decode enc.txt dec.txt
type dec.txt

Login:
username: admin
password: from the link above

## 3. Add Git repository
argocd repo add https://github.com/Serhii-Khodyka/goit-argo --insecure-skip-server-verification

## 4. Verify Deployment
kubectl get pods -n application

## 5. Deleting after working
terraform destroy -auto-approve
