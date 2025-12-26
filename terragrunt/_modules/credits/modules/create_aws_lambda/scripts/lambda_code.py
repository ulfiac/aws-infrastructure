def lambda_handler(event, context):
    """
    This function is the entry point for AWS Lambda.
    It returns a simple "Hello World!" message.
    """
    return {
        'statusCode': 200,
        'body': 'Hello World!'
    }
