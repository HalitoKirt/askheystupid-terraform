import json
import os
import boto3
from botocore.exceptions import ClientError

bedrock = boto3.client("bedrock-runtime")

MODEL_ID = os.environ.get(
    "BEDROCK_MODEL_ID",
    "us.anthropic.claude-haiku-4-5-20251001-v1:0",
)

SYSTEM_PROMPT = (
    "You are Ask Hey Stupid. "
    "Give exactly one short, absurd, playful answer. "
    "Keep it under 20 words. "
    "Do not explain yourself."
)


def response(status_code: int, body: dict) -> dict:
    return {
        "statusCode": status_code,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Headers": "Content-Type",
            "Access-Control-Allow-Methods": "OPTIONS,POST",
        },
        "body": json.dumps(body),
    }


def extract_text(converse_response: dict) -> str:
    output = converse_response.get("output", {})
    message = output.get("message", {})
    content = message.get("content", [])

    text_parts = []
    for item in content:
        text = item.get("text")
        if text:
            text_parts.append(text)

    return " ".join(text_parts).strip()


def lambda_handler(event, context):
    try:
        method = (
            event.get("requestContext", {})
            .get("http", {})
            .get("method", "")
        )

        if method == "OPTIONS":
            return response(200, {"ok": True})

        body = json.loads(event.get("body") or "{}")
        question = (body.get("question") or "").strip()

        if not question:
            return response(400, {"error": "Missing question"})

        converse_response = bedrock.converse(
            modelId=MODEL_ID,
            system=[{"text": SYSTEM_PROMPT}],
            messages=[
                {
                    "role": "user",
                    "content": [{"text": question}],
                }
            ],
            inferenceConfig={
                "maxTokens": 60,
                "temperature": 0.9,
            },
        )

        answer = extract_text(converse_response) or "I forgot how words work."

        return response(200, {"answer": answer})

    except ClientError as e:
        return response(
            500,
            {
                "error": "Bedrock invocation failed",
                "details": str(e),
            },
        )
    except Exception as e:
        return response(
            500,
            {
                "error": "Unhandled backend error",
                "details": str(e),
            },
        )
