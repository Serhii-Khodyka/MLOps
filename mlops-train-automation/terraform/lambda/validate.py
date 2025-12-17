import json

def lambda_handler(event, context):
    print("Validating data...")
    # умовна логіка
    if "source" in event:
        validation_status = "success"
    else:
        validation_status = "failed"

    return {
        "status": validation_status,
        "message": "Validation completed",
        "input_event": event
    }
