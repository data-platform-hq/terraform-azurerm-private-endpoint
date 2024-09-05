# Azure Private Endpoint Terraform module
Terraform module for creation Azure Private Endpoint

## Usage
This module provisions Azure Private Endpoint, for instance, it is possible to create Private Endpoint for compliant Azure Services, create Private DNS Zone Group for that Private Endpoint and even associate additional ip address to Private Endpoint DNS A Record

Below is an example on how to create Private Endpoint for Storage Account's Data Lake File System Gen2 and associate it with certain Private DNS Zone:

```hcl
data "azurerm_subnet" "example" {
  name                 = "example_subnet"
  virtual_network_name = "example_vnet"
  resource_group_name  = "example_rg"
}

data "azurerm_storage_account" "example" {
  name           = "example_storage_account"
  resource_group = "example_rg"
}

data "azurerm_private_dns_zone" "example" {
  name                = "privatelink.dfs.core.windows.net"
  resource_group_name = "example_rg"
}

module "private_endpoint" {
  source   = "data-platform-hq/private-endpoint/azurerm"
  version  = "~> 1.2"
  
  private_endpoint_name  = "pep-dlz-example-eastus-1"
  location               = "eastus"
  resource_group         = "example_rg"
  subnet_id              = data.azurerm_subnet.example.id
  connection_resource_id = data.azurerm_storage_account.example.id
  subresource_names      = "dfs"
  private_dns_zone_id    = [data.azurerm_private_dns_zone.example.id]
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.0.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 4.0.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_private_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_connection_resource_id"></a> [connection\_resource\_id](#input\_connection\_resource\_id) | The ID of the Private Link Enabled Remote Resource which this Private Endpoint should be connected to. | `string` | n/a | yes |
| <a name="input_is_mutual_connection"></a> [is\_mutual\_connection](#input\_is\_mutual\_connection) | Does the Private Endpoint require Manual Approval from the remote resource owner? | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure location | `string` | n/a | yes |
| <a name="input_network_interface_name"></a> [network\_interface\_name](#input\_network\_interface\_name) | Custom Network Interface name | `string` | `null` | no |
| <a name="input_private_dns_zone_id"></a> [private\_dns\_zone\_id](#input\_private\_dns\_zone\_id) | Specifies the set of Private DNS Zones to include within the Private DNS Zone Group | `set(string)` | `[]` | no |
| <a name="input_private_endpoint_name"></a> [private\_endpoint\_name](#input\_private\_endpoint\_name) | Private Endpoint name | `string` | n/a | yes |
| <a name="input_private_service_connection_name"></a> [private\_service\_connection\_name](#input\_private\_service\_connection\_name) | Custom Service Connection name of Private Endpoints | `string` | `null` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | Resource group where Private Endpoint would be created | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint. | `string` | n/a | yes |
| <a name="input_subresource_names"></a> [subresource\_names](#input\_subresource\_names) | A list of subresource names which the Private Endpoint is able to connect to. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | tags for resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_custom_dns_configs"></a> [custom\_dns\_configs](#output\_custom\_dns\_configs) | Custom DNS Record properties. If a Private DNS Zone Group has been defined and is currently connected correctly this block will be empty |
| <a name="output_id"></a> [id](#output\_id) | Id of Private Endpoint |
| <a name="output_name"></a> [name](#output\_name) | Name of Private Endpoint |
| <a name="output_private_dns_zone_configs"></a> [private\_dns\_zone\_configs](#output\_private\_dns\_zone\_configs) | DNS Zone Group Record properties. If a Private DNS Zone Group has not been configured correctly the record\_sets attributes will be empty. |
<!-- END_TF_DOCS -->

## License

Apache 2 Licensed. For more information please see [LICENSE](https://github.com/data-platform-hq/terraform-azurerm-private-endpoint/blob/main/LICENSE)
