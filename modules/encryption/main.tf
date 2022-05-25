resource "aws_kms_key" "kubernetes_secrets_encryption_key" {
  description             = "${var.org}-${var.environment}-kubernetes-secret-emcyrption-key"
  deletion_window_in_days = 10
  tags                    = var.tags
}

resource "aws_kms_alias" "kubernetes_secrets_encryption_key" {
  name          = "alias/${var.org}-${var.environment}-kubernetes-secrets-enccryption-key"
  target_key_id = aws_kms_key.kubernetes_secrets_encryption_key.id
}