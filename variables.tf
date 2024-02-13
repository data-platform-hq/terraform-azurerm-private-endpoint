variable "private_endpoint_name" {
  type = string
  description = "Private Endpoint name"
}

variable "location" {
  type        = string
  description = "Azure location"
}

variable "resource_group" {
  type        = string
  description = "Resource group where Private Endpoint would be created"
}

variable "subnet_id" {
  type        = string
  description = "The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint."
}

variable "connection_resource_id" {
  type        = string
  description = "The ID of the Private Link Enabled Remote Resource which this Private Endpoint should be connected to."
}

variable "subresource_names" {
  type        = string
  description = "A list of subresource names which the Private Endpoint is able to connect to. "
}

variable "network_interface_name" {
  type = string
  description = "Custom Network Interface name"
  default = null
}

variable "private_service_connection_name" {
  type = string
  description = "Custom Service Connection name of Private Endpoints"
  default = null
}

#variable "prefix" {
#  type        = string
#  description = "Prefix used for name creation"
#  default     = ""
#}

variable "tags" {
  type        = map(string)
  description = "tags for resources"
  default     = {}
}

variable "is_mutual_connection" {
  type        = bool
  description = "Does the Private Endpoint require Manual Approval from the remote resource owner?"
  default     = false
}

variable "private_dns_zone_id" {
  type        = set(string)
  description = "Specifies the set of Private DNS Zones to include within the Private DNS Zone Group"
  default     = []
}
variable "private_dns_zone_name" {
  type        = string
  description = "Name of external Private DNS Zone. Used for additional IP association within A Record Set"
  default     = ""
}

variable "private_dns_zone_resource_group" {
  type        = string
  description = "Name of Resource Group where external Private DNS Zone exists. Used for additional IP association within A Record Set"
  default     = ""
}

#variable "additional_ips" {
#  type        = list(string)
#  description = "List of additional IPs to include in A Record of Private Endpoint. Used for additional IP association within A Record Set"
#  default     = []
#}
