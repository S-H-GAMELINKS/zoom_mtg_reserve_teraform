resource "aws_apigatewayv2_api" "zoom_recording_save_http_api" {
  name          = "zoom_recording_save_http_api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "zoom_recording_save_http_api_stage" {
  api_id = aws_apigatewayv2_api.zoom_recording_save_http_api.id
  name   = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_route" "zoom_recording_save_http_api_route" {
  api_id    = aws_apigatewayv2_api.zoom_recording_save_http_api.id
  route_key = "POST /zoom_recording_save"
  target    = "integrations/${aws_apigatewayv2_integration.zoom_recording_save_http_api_integration.id}"
}

resource "aws_lambda_permission" "zoom_recording_save_http_api_permission" {
  function_name = aws_lambda_function.zoom_recording_save.function_name
  principal     = "apigateway.amazonaws.com"
  action        = "lambda:InvokeFunction"
 
  source_arn = "${aws_apigatewayv2_api.zoom_recording_save_http_api.execution_arn}/*"
}

resource "aws_apigatewayv2_integration" "zoom_recording_save_http_api_integration" {
  api_id           = aws_apigatewayv2_api.zoom_recording_save_http_api.id
  integration_type = "AWS_PROXY"
  payload_format_version = "2.0"
  connection_type           = "INTERNET"
  integration_method        = "POST"
  integration_uri           = aws_lambda_function.zoom_recording_save.invoke_arn
}
