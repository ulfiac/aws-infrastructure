# https://docs.aws.amazon.com/nova/latest/userguide/complete-request-schema.html

import json
import boto3

def lambda_handler(event, context):
    """
    AWS Lambda function to interact with Amazon Bedrock Converse API.
    """

    # extract the model id from the event, return if not present
    try:
        model_id = event['model_id']
    except KeyError:
        return {
            'statusCode': 400,
            'body': json.dumps('Error: "model_id" is required in the event payload.')
        }

    # extract the prompt from the event, return if not present
    try:
        prompt = event['prompt']
    except KeyError:
        return {
            'statusCode': 400,
            'body': json.dumps('Error: "prompt" is required in the event payload.')
        }

    # extract the aws region from the event, return if not present
    try:
        aws_region = event['aws_region']
    except KeyError:
        return {
            'statusCode': 400,
            'body': json.dumps('Error: "aws_region" is required in the event payload.')
        }

    # extract the timestamp from the event, return if not present
    try:
        timestamp = event['timestamp']
    except KeyError:
        return {
            'statusCode': 400,
            'body': json.dumps('Error: "timestamp" is required in the event payload.')
        }

    # init boto3 bedrock-runtime client
    bedrock_runtime = boto3.client(
        service_name='bedrock-runtime',
        region_name=aws_region
    )

    # define messages for the model
    messages = [
        {
            "role": "user",
            "content": [{"text": prompt}]
        }
    ]

    # set inference configuration
    inference_config = {
        "maxTokens": 512,
        "temperature": 0.5
    }

    try:
        # call the method
        response = bedrock_runtime.converse(
            modelId=model_id,
            messages=messages,
            inferenceConfig=inference_config
        )

        # extract the model's response text
        model_output = response['output']['message']['content'][0]['text']

        return {
            'aws_region': aws_region,
            'model_id': model_id,
            'statusCode': 200,
            'timestamp': timestamp,
            'body': json.dumps({
                'prompt': prompt,
                'response': model_output
            })
        }

    except Exception as e:
        return {
            'aws_region': aws_region,
            'model_id': model_id,
            'statusCode': 500,
            'timestamp': timestamp,
            'body': json.dumps({
                'prompt': prompt,
                'response': str(e)
            })
        }
