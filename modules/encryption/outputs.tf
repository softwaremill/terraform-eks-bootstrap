output "kubernetes_secrets_encryption_key_arn" {
  value = aws_kms_key.kubernetes_secrets_encryption_key.arn
}

output "kubernetes_secrets_encryption_alias_arn" {
  value = aws_kms_alias.kubernetes_secrets_encryption_key.arn
}
