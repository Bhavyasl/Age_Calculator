output "alb_dns_name" {
  value = aws_lb.app_lb.dns_name
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app_repo.repository_url
}
