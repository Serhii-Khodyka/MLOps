import mlflow
import mlflow.sklearn
import os
import shutil
from sklearn.datasets import load_iris
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, log_loss
from prometheus_client import CollectorRegistry, Gauge, push_to_gateway

# =============================
# Налаштування сервісів
# =============================

MLFLOW_TRACKING_URI = "http://mlflow.mlflow.svc.cluster.local:5000"
PUSHGATEWAY_URL = "http://pushgateway.monitoring.svc.cluster.local:9091"

mlflow.set_tracking_uri(MLFLOW_TRACKING_URI)
mlflow.set_experiment("IrisExperiment")

# =============================
# Дані
# =============================

X, y = load_iris(return_X_y=True)

# Набір параметрів (імітуємо learning_rate та epochs через C і max_iter)
params_grid = [
    {"C": 0.1, "max_iter": 200},
    {"C": 0.5, "max_iter": 200},
    {"C": 1.0, "max_iter": 300},
    {"C": 5.0, "max_iter": 400},
]

best_accuracy = 0
best_run_id = None

# =============================
# Основний цикл тренування
# =============================

for params in params_grid:
    with mlflow.start_run() as run:
        run_id = run.info.run_id

        # Тренувальний/тестовий спліт
        X_train, X_test, y_train, y_test = train_test_split(
            X, y, test_size=0.2, random_state=42
        )

        # Створення моделі
        model = LogisticRegression(**params)
        model.fit(X_train, y_train)

        # Прогнози
        preds = model.predict(X_test)
        probas = model.predict_proba(X_test)

        # Метрики
        accuracy = accuracy_score(y_test, preds)
        loss = log_loss(y_test, probas)

        # ----------------------------
        # Логування в MLflow
        #-----------------------------
        mlflow.log_params(params)
        mlflow.log_metrics({"accuracy": accuracy, "loss": loss})

        # Логування моделі
        mlflow.sklearn.log_model(model, "model")

        # ----------------------------
        # Пуш у PushGateway
        # ----------------------------
        registry = CollectorRegistry()

        acc_g = Gauge("mlflow_accuracy", "Accuracy per run", ["run_id"], registry=registry)
        loss_g = Gauge("mlflow_loss", "Loss per run", ["run_id"], registry=registry)

        acc_g.labels(run_id=run_id).set(accuracy)
        loss_g.labels(run_id=run_id).set(loss)

        push_to_gateway(PUSHGATEWAY_URL, job="iris_training", registry=registry)

        # ----------------------------
        # Оновлення найкращого результату
        # ----------------------------
        if accuracy > best_accuracy:
            best_accuracy = accuracy
            best_run_id = run_id

print("\n=============================")
print("Best run:", best_run_id)
print("Best accuracy:", best_accuracy)
print("=============================\n")

# =============================
# Копіювання найкращої моделі
# =============================

best_model_path = f"mlruns/0/{best_run_id}/artifacts/model"
output_dir = "best_model"

if os.path.exists(output_dir):
    shutil.rmtree(output_dir)

shutil.copytree(best_model_path, output_dir)

print("Best model saved to best_model/")
