resource "aws_cloudformation_stack" "opszero_omyac" {
  count        = var.opszero_omyac_enabled ? 1 : 0
  name         = "opszero-omyac"
  template_url = "https://api.opszero.com/omyac/api/cloudformation"
}

resource "aws_cloudformation_stack" "opszero_ri" {
  count        = var.opszero_ri_enabled ? 1 : 0
  name         = "opszero-ri"
  template_url = "https://api.opszero.com/ri/api/cloudformation"
}

resource "aws_cloudformation_stack" "opszero_reseller" {
  count        = var.opszero_reseller_enabled ? 1 : 0
  name         = "opszero-reseller"
  template_url = "https://api.opszero.com/reseller/api/cloudformation"
}

