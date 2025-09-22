module "component" {
  for_each = var.component
  source = "git::https://github.com/ShivanathBabu/component-modules.git?ref=main"
  component = each.key
  rule_priority = each.value.rule_priority
}