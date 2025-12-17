terraform {
  required_version = ">= 1.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ------------------------
# IAM Role for Lambda
# ------------------------
resource "aws_iam_role" "lambda_role" {
  name = "${var.project_prefix}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "lambda.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# ------------------------
# Lambda: validate
# ------------------------
resource "aws_lambda_function" "validate" {
  function_name = "${var.project_prefix}-validate"
  runtime       = "python3.12"
  handler       = "validate.lambda_handler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/lambda/validate.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda/validate.zip")
}

# ------------------------
# Lambda: log_metrics
# ------------------------
resource "aws_lambda_function" "log_metrics" {
  function_name = "${var.project_prefix}-log-metrics"
  runtime       = "python3.12"
  handler       = "log_metrics.lambda_handler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/lambda/log_metrics.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda/log_metrics.zip")
}

# ------------------------
# IAM for Step Function
# ------------------------
resource "aws_iam_role" "step_function_role" {
  name = "${var.project_prefix}-sf-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "states.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "step_function_policy" {
  role = aws_iam_role.step_function_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [ "lambda:InvokeFunction" ],
        Effect = "Allow",
        Resource = [
          aws_lambda_function.validate.arn,
          aws_lambda_function.log_metrics.arn
        ]
      }
    ]
  })
}

# ------------------------
# Step Function Definition
# ------------------------
locals {
  step_definition = jsonencode({
    Comment = "ML Training Pipeline",
    StartAt = "ValidateData",
    States = {
      ValidateData = {
        Type = "Task",
        Resource = aws_lambda_function.validate.arn,
        Next = "LogMetrics"
      },
      LogMetrics = {
        Type = "Task",
        Resource = aws_lambda_function.log_metrics.arn,
        End   = true
      }
    }
  })
}

resource "aws_sfn_state_machine" "train_pipeline" {
  name     = "${var.project_prefix}-pipeline"
  role_arn = aws_iam_role.step_function_role.arn
  definition = local.step_definition
}
