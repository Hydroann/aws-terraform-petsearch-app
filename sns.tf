# ── Topic 1: Lost Pet Alert ───────────────────────────────────────────────────

resource "aws_sns_topic" "lost_pet" {
  name         = "${local.name_prefix}-lost-pet"
  display_name = "PetSearch: Lost Pet Alert"

  tags = { Name = "${local.name_prefix}-lost-pet" }
}

resource "aws_sns_topic_subscription" "lost_pet_email" {
  topic_arn = aws_sns_topic.lost_pet.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# ── Topic 2: Match Found ──────────────────────────────────────────────────────

resource "aws_sns_topic" "match_found" {
  name         = "${local.name_prefix}-match-found"
  display_name = "PetSearch: Match Found"

  tags = { Name = "${local.name_prefix}-match-found" }
}

resource "aws_sns_topic_subscription" "match_found_email" {
  topic_arn = aws_sns_topic.match_found.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# ── Topic 3: Adoption Request ─────────────────────────────────────────────────

resource "aws_sns_topic" "adoption_request" {
  name         = "${local.name_prefix}-adoption-request"
  display_name = "PetSearch: Adoption Request"

  tags = { Name = "${local.name_prefix}-adoption-request" }
}

resource "aws_sns_topic_subscription" "adoption_request_email" {
  topic_arn = aws_sns_topic.adoption_request.arn
  protocol  = "email"
  endpoint  = var.alert_email
}
