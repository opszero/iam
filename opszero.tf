resource "aws_cloudformation_stack" "opszero" {
  count = var.opszero_enabled ? 1 : 0

  name         = "opszero"
  template_url = "https://api.opszero.com/cloud/cloudformation"
}
