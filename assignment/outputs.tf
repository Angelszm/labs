output "arn" {
  value       = aws_ecr_repository.counter-app.arn
  description = "Full ARN to image in ECR with Tag"
}