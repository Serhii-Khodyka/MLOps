# AWS VPC + EKS Cluster Deployment (Terraform)
## Lesson 5–6

Цей проєкт автоматизує розгортання AWS інфраструктури за допомогою Terraform:
- створення VPC (підмережі, маршрути, NAT, IGW)
- створення EKS-кластера
- створення двох node groups (CPU + GPU)
- збереження стану Terraform у S3 backend
- автоматичний доступ до кластера через `kubectl`

Структура проекта
eks-vpc-cluster/
├── backend.tf 
├── terraform.tf # Providers
├── variables.tf # Глобальні змінні
├── outputs.tf # Глобальні outputs
├── main.tf # Виклики модулів VPC та EKS
│
├── vpc/
│ ├── main.tf
│ ├── variables.tf
│ ├── outputs.tf
│ ├── terraform.tf
│ └── backend.tf 
│
├── eks/
│ ├── main.tf
│ ├── variables.tf
│ ├── outputs.tf
│ ├── terraform.tf
│ └── backend.tf 
└── README.md


У файлі eks/main.tf заміни на свою локальну IP-адресу, щоб не відкривати доступ до кластеру будь-якому ІР
cluster_endpoint_public_access_cidrs = [
  "79.110.134.144/32"
]

Створи AWS Access Key → IAM → Users → Security Credentials
Потім:
aws configure

Вкажи доступ:
AWS Access Key ID     = …
AWS Secret Access Key = …
Default region        = us-east-1
Default output        = json

Створи S3 bucket:
aws s3 mb s3://serhii-my-tf-state-bucket --region us-east-1

Запуск проєкту
1️⃣ Ініціалізація Terraform
terraform init -reconfigure

2️⃣ Перевірка плану
terraform plan

3️⃣ Створення інфраструктури
terraform apply

Орієнтовний час виконання: 15–25 хвилин

Підключення до EKS
Після закінчення terraform apply:
aws eks update-kubeconfig \
  --region us-east-1 \
  --name eks-demo-cluster 

Перевірка:
kubectl get nodes


Outputs
Після успішного деплою Terraform поверне:
vpc_id
public_subnets
private_subnets
cluster_name
cluster_endpoint
cluster_security_group_id

Корисні команди
Видалити інфраструктуру:
terraform destroy

Оновити модулі:
terraform get --update