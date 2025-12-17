# MLops Train Automation — AWS Step Functions + Lambda + Terraform + GitLab CI

## 📌 Опис
Проєкт автоматизує запуск ML-пайплайну через AWS Step Functions, Lambda та GitLab CI.

Pipeline складається з 2 етапів:
1. ValidateData (Lambda)
2. LogMetrics (Lambda)

---

## 📁 Структура проєкту
mlops-train-automation/
├── terraform/
│  ├── main.tf
│  ├── variables.tf
│  └── lambda/
│    ├── validate.py
│    ├── log_metrics.py
│    ├── validate.zip
│    └── log_metrics.zip
├── .gitlab-ci.yml
|── .github/
|   └── workflows/
|       └──train.yaml
├── README.md


---
1.Збірка Lambda-функцій

```bash
cd terraform/lambda
zip validate.zip validate.py
zip log_metrics.zip log_metrics.py

2. Деплой інфраструктури (Terraform)

cd terraform
terraform init
terraform apply

Після деплою буде створено:
2 Lambda-функції
IAM ролі
Step Function pipeline
JSON-машина станів

3. Запуск Step Function вручну (візьми свій ARN і зроби відповідні зміни в команді нижче)
Step Functions → State machines → mlops-train-pipeline → ARN

aws stepfunctions start-execution --state-machine-arn arn:aws:states:us-east-1:182399680937:stateMachine:mlops-train-pipeline --name test-run-1 --input '{"source":"manual"}'

Якщо працюєш в PowerShell і виникає помилка, то потрібно додаткові кроки
Створи файл з input
Set-Content -Path input.json -Value '{ "source": "manual" }'

Перевір Get-Content input.json
Очікувана відповідь { "source": "manual" }

Потім запускай Step Function вручну

4. GitHub 
GitHub запускає Step Function при пуші в main.

Також в main потрібно розмістити .github/workflows/train.yaml

Додай змінні CI як Environment secrets для prod: 
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_DEFAULT_REGION
STEP_FUNCTION_ARN


