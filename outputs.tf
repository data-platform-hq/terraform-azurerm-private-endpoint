output "id" {
  value       = azurerm_private_endpoint.this.id
  description = "Id of Private Endpoint"
}

output "custom_dns_configs" {
  value       = azurerm_private_endpoint.this.custom_dns_configs
  description = "Custom DNS Record properties. If a Private DNS Zone Group has been defined and is currently connected correctly this block will be empty"
}

output "private_dns_zone_configs" {
  value       = azurerm_private_endpoint.this.private_dns_zone_configs
  description = "DNS Zone Group Record properties. If a Private DNS Zone Group has not been configured correctly the record_sets attributes will be empty."
}
