module "cart" {
  source = "git::https://github.com/ShivanathBabu/component-modules.git?ref=main"
  component = "cart"
  rule_priority = 40
}