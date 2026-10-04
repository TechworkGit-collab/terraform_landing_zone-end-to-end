variable "azurerm_lb" {
  type = object({
    name     = string
    location = string
    rg_name  = string
  })
}

variable "nic" {
  type = map(object({
    nic_name = string
    resource_group_name  = string
  }))
}

