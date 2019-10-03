resource "aws_lambda_function" "put_sensor_data_lambda" {
  function_name = "PutSensorDataLambda"
  handler = "org.limr.lambdas.putsensordatalambda.PutSensorDataLambda"
  runtime = "java8"
  filename = "../lambdas/putSensorDataLambda/target/PutSensorDataLambda-1.0.jar"
  memory_size = "1024"
  timeout = 50
  source_code_hash = "${filebase64sha256("../lambdas/putSensorDataLambda/target/PutSensorDataLambda-1.0.jar")}"
  role = "${aws_iam_role.put_sensor_data_exec_role.arn}"
  depends_on    = ["aws_iam_role_policy_attachment.put_sensor_data_lambda_logs", "aws_cloudwatch_log_group.put_sensor_data_lambda"]

  environment {
    variables = {
      TABLE_NAME = "${var.sensor_data_name_prefix}"
    }
  }
}

resource "aws_iam_role_policy_attachment" "put_sensor_data_dynamodb_access" {
  role = "${aws_iam_role.put_sensor_data_exec_role.name}"
  policy_arn = "${aws_iam_policy.dynamodb_access.arn}"
}

resource "aws_iam_role" "put_sensor_data_exec_role" {
  name = "PutSensorDataLambdaExecRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_lambda_permission" "put_sensor_data_apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.put_sensor_data_lambda.function_name}"
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.aws_region}:${var.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.put_sensor_data.http_method}${aws_api_gateway_resource.resource.path}"
}