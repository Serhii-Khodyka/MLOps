import json
import time

def lambda_handler(event, context):
    print("Logging metrics...")
    metrics = {
        "accuracy": 0.92,
        "loss": 0.13,
        "timestamp": int(time.time()),
        "source_event": event
    }

    return {
        "status": "logged",
        "metrics": metrics
    }
