resource "azurerm_public_ip" "publicip" {
  name                = "PublicIPForLB"
  location            = var.azurerm_lb.location
  resource_group_name = var.azurerm_lb.rg_name
  allocation_method   = "Static"
}



resource "azurerm_lb" "lb" {
  name                = var.azurerm_lb.name
  location            = var.azurerm_lb.location
  resource_group_name = var.azurerm_lb.rg_name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.publicip.id
  }
}

resource "azurerm_lb_backend_address_pool" "backendpool" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "hp" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "http-running-probe"
  protocol        = "Http"
  port            = 80
  request_path    = "/"
}

resource "azurerm_lb_rule" "lbrule" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"

  backend_address_pool_ids = [
    azurerm_lb_backend_address_pool.backendpool.id
  ]

  probe_id = azurerm_lb_probe.hp.id
}

# resource "azurerm_network_interface_backend_address_pool_association" "nic" {

#   for_each = data.azurerm_network_interface.nic

#   network_interface_id    = each.value.id
#   ip_configuration_name   = each.value.ip_configuration_name
#   backend_address_pool_id = azurerm_lb_backend_address_pool.backendpool.id
# }
resource "azurerm_network_interface_backend_address_pool_association" "nic" {
  for_each = var.nic

  network_interface_id = data.azurerm_network_interface.nic[each.key].id

  ip_configuration_name = data.azurerm_network_interface.nic[each.key].ip_configuration[0].name

  backend_address_pool_id = azurerm_lb_backend_address_pool.backendpool.id
}