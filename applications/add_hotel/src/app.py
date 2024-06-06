import json


def handler(event, context):
    print(f"value 1 = {event['key1']}")
    return event["key1"]
