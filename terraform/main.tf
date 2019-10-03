provider "aws" {
  region  = "${var.aws_region}"
  profile = "limr"
}

variable "account_id" {
  type = "string"
  default = "592986159531"
}
variable "sensor_data_name_prefix" {
  type = "string"
  default = "SensorData"
}

resource "aws_dynamodb_table" "sensorData" {
  name = "${var.sensor_data_name_prefix}0"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "SensorID"

  attribute {
    name = "SensorID"
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
