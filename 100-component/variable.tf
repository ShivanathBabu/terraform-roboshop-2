variable "component" {
  default = {
    cart = {    #key
        rule_priority = 30    #value
    }
    shipping = {
        rule_priority = 40
    }
    payment = {
        rule_priority = 50
    }
    frontend = {
        rule_priority = 60
    }

  }
}