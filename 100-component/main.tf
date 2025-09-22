module "component" {
  for_each = var.component
  source = "../../component-modules"
  component = each.key
  rule_priority = each.value.rule_priority
}