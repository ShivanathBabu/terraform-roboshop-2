module "payment" {
  source = "git::https://github.com/ShivanathBabu/component-modules.git?ref=main"
  rule_priority = 60
  component = "payment"
}