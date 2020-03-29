resource "aws_lambda_function" "audio_lambda" {
  function_name = "AudioLambda"
  handler = "org.limr.lambdas.audiolambda.AudioLambda"
  runtime = "java8"
  filename = "../lambdas/audioLambda/target/AudioLambda-1.0.jar"
  memory_size = "1024"
  timeout = 50
  source_code_hash = "${filebase64sha256("../lambdas/audioLambda/target/AudioLambda-1.0.jar")}"
  role = "${aws_iam_role.audio_exec_role.arn}"
  depends_on    = ["aws_iam_role_policy_attachment.audio_lambda_logs", "aws_cloudwatch_log_group.audio_lambda"]

  environment {
    variables = {
      TABLE_NAME = "AudioDatabase0"
    }
  }
}

resource "aws_iam_role_policy_attachment" "audio_dynamodb_access" {
  role = "${aws_iam_role.audio_exec_role.name}"
  policy_arn = "${aws_iam_policy.dynamodb_access.arn}"
}

resource "aws_iam_role" "audio_exec_role" {
  name = "AudioLambdaExecRole"

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


resource "aws_lambda_permission" "audio_apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.audio_lambda.function_name}"
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.aws_region}:${var.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.audio.http_method}${aws_api_gateway_resource.audio.path}"
}