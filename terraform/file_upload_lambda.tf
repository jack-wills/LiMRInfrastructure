resource "aws_lambda_function" "file_upload_lambda" {
  function_name = "FileUploadLambda"
  handler = "org.proxily.lambdas.fileuploadlambda.FileUploadLambda"
  runtime = "java8"
  filename = "../lambdas/fileUploadLambda/target/FileUploadLambda-1.0.jar"
  memory_size = "1024"
  timeout = 50
  source_code_hash = filebase64sha256("../lambdas/fileUploadLambda/target/FileUploadLambda-1.0.jar")
  role = aws_iam_role.file_upload_exec_role.arn
  depends_on    = [aws_iam_role_policy_attachment.file_upload_lambda_logs, aws_cloudwatch_log_group.file_upload_lambda]

  environment {
    variables = {
      TABLE_NAME = "ImageDatabase0"
      QUEUE_URL = aws_sqs_queue.image_queue.id
    }
  }
}

resource "aws_iam_role_policy_attachment" "file_upload_dynamodb_access" {
  role = aws_iam_role.file_upload_exec_role.name
  policy_arn = aws_iam_policy.dynamodb_access.arn
}

resource "aws_iam_role_policy_attachment" "file_upload_sqs_access" {
  role = aws_iam_role.file_upload_exec_role.name
  policy_arn = aws_iam_policy.sqs_access.arn
}

resource "aws_iam_role" "file_upload_exec_role" {
  name = "FileUploadLambdaExecRole"

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

resource "aws_lambda_permission" "allow_bucket_image" {
  statement_id  = "AllowExecutionFromS3BucketImage"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.file_upload_lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.image_bucket.arn
}

resource "aws_s3_bucket_notification" "bucket_notification_image" {
  bucket = aws_s3_bucket.image_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.file_upload_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }
}