module "frontend" {
  source = "git::https://github.com/ShivanathBabu/component-modules.git?ref=main"
  component = "frontend"
  rule_priority = 20

}