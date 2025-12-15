MLflow + PushGateway + ArgoCD Experiments

Опис
Проєкт демонструє:
- трекінг ML-експериментів у MLflow,
- логування параметрів, метрик та артефактів,
- автоматичний вибір найкращої моделі,
- пуш метрик у Prometheus PushGateway,
- перегляд метрик у Grafana,
- повністю декларативне розгортання через ArgoCD.

Як розгорнути інфраструктуру

Додати додатки в ArgoCD
У директорії `argocd/applications` містяться:
- `mlflow.yaml`
- `minio.yaml`
- `postgres.yaml`
- `pushgateway.yaml`

Застосувати всі маніфести:

```bash
kubectl apply -f argocd/applications/ -n argocd

Перевірка MLflow
kubectl port-forward svc/mlflow 5000:5000 -n mlflow


UI доступний за адресою:

http://localhost:5000


Перевірка PushGateway
kubectl get svc -n monitoring


DNS:

pushgateway.monitoring.svc.cluster.local:9091

Запуск тренування
cd experiments
pip install -r requirements.txt
python train_and_push.py


Після виконання:

найкраща модель → best_model/
метрики → MLflow UI
Prometheus метрики → Grafana

Перегляд у Grafana

Перейти:
Grafana → Explore → Prometheus

Запити параметрів: 
mlflow_accuracy
mlflow_loss