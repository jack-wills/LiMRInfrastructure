resource "aws_cloudwatch_log_group" "put_sensor_data_lambda" {
  name              = "/aws/lambda/PutSensorDataLambda"
  retention_in_days = 14
}
resource "aws_cloudwatch_log_group" "get_sensor_data_lambda" {
  name              = "/aws/lambda/GetSensorDataLambda"
  retention_in_days = 14
}
resource "aws_cloudwatch_log_group" "upload_image_lambda" {
  name              = "/aws/lambda/UploadImageLambda"
  retention_in_days = 14
}
resource "aws_cloudwatch_log_group" "file_upload_lambda" {
  name              = "/aws/lambda/FileUploadLambda"
  retention_in_days = 14
}


# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
resource "aws_iam_policy" "lambda_logging" {
  name = "lambda_logging"
  path = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "put_sensor_data_lambda_logs" {
  role = "${aws_iam_role.put_sensor_data_exec_role.name}"
  policy_arn = "${aws_iam_policy.lambda_logging.arn}"
}

resource "aws_iam_role_policy_attachment" "get_sensor_data_lambda_logs" {
  role = "${aws_iam_role.get_sensor_data_exec_role.name}"
  policy_arn = "${aws_iam_policy.lambda_logging.arn}"
}
resource "aws_iam_role_policy_attachment" "upload_image_lambda_logs" {
  role = "${aws_iam_role.upload_image_exec_role.name}"
  policy_arn = "${aws_iam_policy.lambda_logging.arn}"
}
resource "aws_iam_role_policy_attachment" "file_upload_lambda_logs" {
  role = "${aws_iam_role.file_upload_exec_role.name}"
  policy_arn = "${aws_iam_policy.lambda_logging.arn}"
}