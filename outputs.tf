output "wordpress_url" {
  description = "Open this in your browser to access PetSearch WordPress"
  value       = "http://${aws_lb.main.dns_name}"
}

output "ssh_bastion_command" {
  description = "Ready-to-use command to SSH into the bastion host"
  value       = "ssh -i ~/.ssh/${var.key_name}.pem ec2-user@${aws_subnet.public-petsearch-subnet-1.id}"
}

output "pet_images_bucket" {
  description = "S3 bucket where pet photos are stored"
  value       = aws_s3_bucket.pet_images.bucket
}

output "documents_bucket" {
  description = "S3 bucket where uploaded documents are stored"
  value       = aws_s3_bucket.documents.bucket
}

output "sns_lost_pet_arn" {
  description = "SNS topic ARN for lost pet alerts — publish to this from WordPress"
  value       = aws_sns_topic.lost_pet.arn
}

output "sns_match_found_arn" {
  description = "SNS topic ARN for match found alerts"
  value       = aws_sns_topic.match_found.arn
}

output "sns_adoption_request_arn" {
  description = "SNS topic ARN for adoption request alerts"
  value       = aws_sns_topic.adoption_request.arn
}

