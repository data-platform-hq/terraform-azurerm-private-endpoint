locals {
  additional_ips = join(" ", [for ip in var.additional_ips : "${ip}"])
}

resource "azurerm_private_endpoint" "this" {
  location            = var.location
  name                = "pe-${var.prefix}${var.project}-${var.env}-${var.location}"
  resource_group_name = var.resource_group
  subnet_id           = var.subnet_id
  tags                = var.tags

  dynamic "private_dns_zone_group" {
    for_each = [for zone in var.private_dns_zone_id : zone]
    content {
      name                 = "group-${var.prefix}${var.project}-${var.env}-${var.location}"
      private_dns_zone_ids = [private_dns_zone_group.value]
    }
  }

  private_service_connection {
    name                           = "psc-${var.prefix}${var.project}-${var.env}-${var.location}"
    is_manual_connection           = var.is_mutual_connection
    private_connection_resource_id = var.connection_resource_id
    subresource_names              = [var.subresource_names]
  }
}


resource "null_resource" "additional_ip" {
  count = length(var.private_dns_zone_id) == 0 && length(var.private_dns_zone_name) == 0 && length(var.private_dns_zone_resource_group) == 0 ? 0 : 1

  triggers = {
    zone_resource_group = var.private_dns_zone_resource_group
    zone_name           = var.private_dns_zone_name
    record_name         = trimsuffix(azurerm_private_endpoint.this.private_dns_zone_configs[0].record_sets[0].fqdn, ".${var.private_dns_zone_name}")
    ip_list             = local.additional_ips
  }

  provisioner "local-exec" {
    command     = "bash ./add_ip_to_record.sh \"${self.triggers.zone_resource_group}\" \"${self.triggers.zone_name}\" \"${self.triggers.record_name}\" \"${self.triggers.ip_list}\" "
    working_dir = path.module
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "bash ./remove_ip_from_record.sh \"${self.triggers.zone_resource_group}\" \"${self.triggers.zone_name}\" \"${self.triggers.record_name}\" \"${self.triggers.ip_list}\" "
    working_dir = path.module
  }

  depends_on = [azurerm_private_endpoint.this]
}
