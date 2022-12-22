resource "aws_ecr_repository" "counter-app" {
  name                 = "${var.env}-${var.repo_name}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}