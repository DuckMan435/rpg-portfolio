output "cloudfront_distribution_url" {
  description = "CloudFront Distribution URL"
  value       = aws_cloudfront_distribution.main.domain_name
}

output "api_gateway_endpoint_url" {
  description = "API Gateway endpoint URL"
  value       = aws_apigatewayv2_stage.main.invoke_url
}

output "rds_instance_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.main.endpoint
}
