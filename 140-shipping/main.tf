module "shipping" {
  source = "git::https://github.com/ShivanathBabu/component-modules.git?ref=main"
  component = "shipping"
  rule_priority = 50
}