resource "aws_lambda_function" "lambda" {
  function_name = "HelloUniverse"

  s3_bucket = aws_s3_bucket.bucket.id
  s3_key    = aws_s3_bucket_object.object.key

  runtime = "nodejs12.x"
  handler = "hello.handler"

  source_code_hash = data.archive_file.lambda_hello_universe.output_base64sha256
  role             = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${aws_lambda_function.lambda.function_name}"
  retention_in_days = 1
}
