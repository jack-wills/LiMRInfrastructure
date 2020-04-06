
resource "aws_api_gateway_stage" "stage" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.deployment.id
}

resource "aws_api_gateway_rest_api" "api" {
  name        = "LiMRAPI"
  description = "LiMR endpoint"
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on  = [aws_api_gateway_integration.put_sensor_data, aws_api_gateway_integration.get_sensor_data, aws_api_gateway_integration.upload_image, aws_api_gateway_integration.audio] //add other integration
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "prod"
  stage_description = "Production Deployment"
}

resource "aws_api_gateway_resource" "resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "sensordata"
}
resource "aws_api_gateway_resource" "upload_image" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "uploadimage"
}
resource "aws_api_gateway_resource" "audio" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "audio"
}

resource "aws_api_gateway_method" "put_sensor_data" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "put_sensor_data" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.put_sensor_data.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.put_sensor_data_lambda.invoke_arn
}

resource "aws_api_gateway_method_response" "put_sensor_data_response_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.put_sensor_data.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "put_sensor_data" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.put_sensor_data.http_method
  status_code = aws_api_gateway_method_response.put_sensor_data_response_200.status_code
}

resource "aws_api_gateway_method" "get_sensor_data" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_sensor_data" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.get_sensor_data.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.get_sensor_data_lambda.invoke_arn
  request_templates       = {
    "application/json" = <<EOF
#set($params = $input.params().get("querystring"))
{
#foreach($paramName in $params.keySet())
    "$paramName" : "$util.escapeJavaScript($params.get($paramName))"
#if($foreach.hasNext),#end
#end
}
    EOF
  }
}

resource "aws_api_gateway_method_response" "get_sensor_data_response_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.get_sensor_data.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "get_sensor_data" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.get_sensor_data.http_method
  status_code = aws_api_gateway_method_response.get_sensor_data_response_200.status_code
}


resource "aws_api_gateway_method" "upload_image" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.upload_image.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "upload_image" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.upload_image.id
  http_method             = aws_api_gateway_method.upload_image.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.upload_image_lambda.invoke_arn
}

resource "aws_api_gateway_method_response" "upload_image_response_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.upload_image.id
  http_method = aws_api_gateway_method.upload_image.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "upload_image" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.upload_image.id
  http_method = aws_api_gateway_method.upload_image.http_method
  status_code = aws_api_gateway_method_response.upload_image_response_200.status_code
}


resource "aws_api_gateway_method" "audio" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.audio.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "audio" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.audio.id
  http_method             = aws_api_gateway_method.audio.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.audio_lambda.invoke_arn
}

resource "aws_api_gateway_method_response" "audio_response_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.audio.id
  http_method = aws_api_gateway_method.audio.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "audio" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.audio.id
  http_method = aws_api_gateway_method.audio.http_method
  status_code = aws_api_gateway_method_response.audio_response_200.status_code
}