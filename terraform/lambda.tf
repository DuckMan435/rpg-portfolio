resource "aws_iam_role" "lambda" {
  name = "${var.project_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_lambda_function" "main" {
  function_name    = "${var.project_name}-lambda"
  role             = aws_iam_role.lambda.arn
  handler          = "app.main.handler"
  runtime          = "python3.12"
  filename         = "../lambda.zip"
  source_code_hash = filebase64sha256("../lambda.zip")
  timeout = 30
  memory_size = 512

  vpc_config {
    subnet_ids         = aws_subnet.private[*].id
    security_group_ids = [aws_security_group.lambda.id]
  }

  environment {
    variables = {
      DATABASE_URL = "postgresql://${var.db_username}:${var.db_password}@${aws_db_instance.main.address}:${aws_db_instance.main.port}/${var.db_name}"
      API_PREFIX   = "/api"
    }
  }

  tags = {
    Name = "${var.project_name}-lambda"
  }
}
