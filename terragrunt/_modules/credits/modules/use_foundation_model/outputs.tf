output "converse" {
  value = {
    aws_region  = jsondecode(aws_lambda_invocation.converse.result).aws_region
    model_id    = jsondecode(aws_lambda_invocation.converse.result).model_id
    prompt      = jsondecode(jsondecode(aws_lambda_invocation.converse.result).body).prompt
    response    = jsondecode(jsondecode(aws_lambda_invocation.converse.result).body).response
    status_code = jsondecode(aws_lambda_invocation.converse.result).statusCode
    timestamp   = jsondecode(aws_lambda_invocation.converse.result).timestamp
  }
}

output "invoke_model" {
  value = {
    aws_region  = jsondecode(aws_lambda_invocation.invoke_model.result).aws_region
    model_id    = jsondecode(aws_lambda_invocation.invoke_model.result).model_id
    prompt      = jsondecode(jsondecode(aws_lambda_invocation.invoke_model.result).body).prompt
    response    = jsondecode(jsondecode(aws_lambda_invocation.invoke_model.result).body).response
    status_code = jsondecode(aws_lambda_invocation.invoke_model.result).statusCode
    timestamp   = jsondecode(aws_lambda_invocation.invoke_model.result).timestamp
  }
}
