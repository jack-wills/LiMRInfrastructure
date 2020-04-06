provider "aws" {
  region  = var.aws_region
  profile = "limr"
}

variable "account_id" {
  type = string
  default = "592986159531"
}
variable "sensor_data_name_prefix" {
  type = string
  default = "SensorData"
}

resource "aws_s3_bucket" "image_bucket" {
  bucket = "limr-image-${var.aws_region}"
  acl    = "private"
  lifecycle_rule {
    id      = "expire"
    enabled = true

    expiration {
      days = 7
    }
  }
}

resource "aws_sqs_queue" "image_queue" {
  name = "ImageQueue"
  receive_wait_time_seconds = 5
}

resource "aws_dynamodb_table" "images" {
  name = "ImageDatabase0"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "Timestamp"

  attribute {
    name = "Timestamp"
    type = "S"
  }
}
resource "aws_dynamodb_table" "sensorData" {
  name = "${var.sensor_data_name_prefix}0"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "SensorID"

  attribute {
    name = "SensorID"
    type = "S"
  }
}

resource "aws_dynamodb_table" "audio" {
  name = "AudioDatabase0"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LinkID"

  attribute {
    name = "LinkID"
    type = "S"
  }
}

resource "aws_iam_policy" "dynamodb_access" {
  name = "dynamodb_access"
  path = "/"
  description = "IAM policy for accessing dynamodb"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:*"
      ],
      "Resource": "arn:aws:dynamodb:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "s3_access" {
  name = "s3_access"
  path = "/"
  description = "IAM policy for accessing s3"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EOF
}
resource "aws_iam_policy" "sqs_access" {
  name = "sqs_access"
  path = "/"
  description = "IAM policy for accessing sqs"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sqs:*"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EOF
}
