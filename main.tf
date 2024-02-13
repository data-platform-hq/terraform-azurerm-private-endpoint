
resource "azurerm_private_endpoint" "this" {
  location                      = var.location
  name                          = var.private_endpoint_name
  custom_network_interface_name = coalesce(var.network_interface_name, "nic-${var.private_endpoint_name}")
  resource_group_name           = var.resource_group
  subnet_id                     = var.subnet_id
  tags                          = var.tags

  dynamic "private_dns_zone_group" {
    for_each = [for zone in var.private_dns_zone_id : zone]
    content {
      name                 = "grp-${var.private_endpoint_name}"
      private_dns_zone_ids = [private_dns_zone_group.value]
    }
  }

  private_service_connection {
    name                           = coalesce(var.private_service_connection_name, "psc-${var.private_endpoint_name}")
    is_manual_connection           = var.is_mutual_connection
    private_connection_resource_id = var.connection_resource_id
    subresource_names              = [var.subresource_names]
  }
}
