module "user" {
  source = "git::https://github.com/ShivanathBabu/component-modules.git?ref=main"
  rule_priority = 30
  component = "user"
  
}