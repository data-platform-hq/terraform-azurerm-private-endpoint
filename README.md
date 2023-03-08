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
  
  project                = "datahq"
  env                    = "example"
  location               = "eastus"
  resource_group         = "example_rg"
  prefix                 = "uc"
  subnet_id              = data.azurerm_subnet.example.id
  connection_resource_id = data.azurerm_storage_account.example.id
  subresource_names      = "dfs"
  private_dns_zone_id    = [data.azurerm_private_dns_zone.example.id]
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name                                                                      | Version   |
| ------------------------------------------------------------------------- | --------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0  |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm)       | >= 3.40.0 |
| <a name="requirement_null"></a> [null](#requirement\_null)                | >=3.1.1   |

## Providers

| Name                                                          | Version |
| ------------------------------------------------------------- | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.40.0  |
| <a name="provider_null"></a> [null](#provider\_null)          | 3.1.1   |

## Modules

No modules.

## Resources

| Name                                                                                                                              | Type     |
| --------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [azurerm_private_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [null_resource.additional_ip](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource)              | resource |

## Inputs

| Name                                                                                                                                    | Description                                                                                                               | Type           | Default | Required |
| --------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- | -------------- | ------- | :------: |
| <a name="input_project"></a> [project](#input\_project)                                                                                 | Project name                                                                                                              | `string`       | n/a     |   yes    |
| <a name="input_env"></a> [env](#input\_env)                                                                                             | Environment name                                                                                                          | `string`       | n/a     |   yes    |
| <a name="input_location"></a> [location](#input\_location)                                                                              | Azure location                                                                                                            | `string`       | n/a     |   yes    |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group)                                                          | Resource group where Private Endpoint would be created                                                                    | `string`       | n/a     |   yes    |
| <a name="input_subnet_id"></a> [resource\_subnet\_id](#input\_subnet\_id)                                                               | The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint                          | `string`       | n/a     |   yes    |
| <a name="input_connection_resource_id"></a> [connection\_resource\_id](#input\_connection\_resource\_id)                                | The ID of the Private Link Enabled Remote Resource which this Private Endpoint should be connected to                     | `string`       | n/a     |   yes    |
| <a name="input_subresource_names"></a> [subresource\_names](#input\_subresource\_names)                                                 | A list of subresource names which the Private Endpoint is able to connect to                                              | `string`       | n/a     |   yes    |
| <a name="input_prefix"></a> [prefix](#input\_prefix)                                                                                    | Prefix used for name creation                                                                                             | `string`       | ""      |    no    |
| <a name="input_tags"></a> [tags](#input\_tags)                                                                                          | tags for resources                                                                                                        | `map(string)`  | {}      |    no    |
| <a name="input_custom_private_endpoint_name"></a> [custom\_private\_endpoint\_name](#input\_custom\_private\_endpoint\_name)            | Specifies the Name of the Private Endpoint                                                                                | `string`       | `null`  |    no    |
| <a name="input_custom_nic_name"></a> [custom\_nic\_name](#input\_custom\_nic\_name)                                                     | The custom name of the network interface attached to the private endpoint                                                 | `string`       | `null`  |    no    |
| <a name="input_custom_dns_zone_group_name"></a> [custom\_dns\_zone\_group\_name](#input\_custom\_dns\_zone\_group\_name)                | Specifies the Name of the Private DNS Zone Group                                                                          | `string`       | `null`  |    no    |
| <a name="input_custom_service_connection_name"></a> [custom\_service\_connection\_name](#input\_custom\_service\_connection\_name)      | Specifies the Name of the Private Service Connection                                                                      | `string`       | `null`  |    no    |
| <a name="input_is_mutual_connection"></a> [is\_mutual\_connection](#input\_is\_mutual\_connection)                                      | Does the Private Endpoint require Manual Approval from the remote resource owner?                                         | `bool`         | false   |    no    |
| <a name="input_private_dns_zone_id"></a> [private\_dns\_zone\_id](#input\_private\_dns\_zone\_id)                                       | Specifies the set of Private DNS Zones to include within the Private DNS Zone Group                                       | `set(string)`  | []      |    no    |
| <a name="input_private_dns_zone_name"></a> [private\_dns\_zone\_name](#input\_private\_dns\_zone\_name)                                 | Name of external Private DNS Zone. Used for additional IP association within A Record Set                                 | `string`       | ""      |    no    |
| <a name="input_private_dns_zone_resource_group"></a> [private\_dns\_zone\_resource\_group](#input\_private\_dns\_zone\_resource\_group) | Name of Resource Group where external Private DNS Zone exists. Used for additional IP association within A Record Set     | `string`       | ""      |    no    |
| <a name="input_additional_ips"></a> [additional\_ips](#input\_additional\_ips)                                                          | List of additional IPs to include in A Record of Private Endpoint. Used for additional IP association within A Record Set | `list(string)` | []      |    no    |

## Outputs

| Name                                                                                                               | Description                                                                                                                              |
| ------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------- |
| <a name="output_id"></a> [id](#output\_id)                                                                         | Id of Private Endpoint                                                                                                                   |
| <a name="output_custom_dns_configs"></a> [custom\_dns\_configs](#output\_custom\_dns\_configs)                     | Custom DNS Record properties. If a Private DNS Zone Group has been defined and is currently connected correctly this block will be empty |
| <a name="output_private_dns_zone_configs"></a> [private\_dns\_zone\_configs](#output\_private\_dns\_zone\_configs) | DNS Zone Group Record properties. If a Private DNS Zone Group has not been configured correctly the record_sets attributes will be empty |
<!-- END_TF_DOCS -->

## License

Apache 2 Licensed. For more information please see [LICENSE](https://github.com/data-platform-hq/terraform-azurerm-private-endpoint/blob/main/LICENSE)