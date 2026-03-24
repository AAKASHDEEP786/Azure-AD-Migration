variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
}

variable "vnet_name" {
  description = "Virtual Network Name"
  type        = string
}

variable "subnet_name" {
  description = "Subnet Name"
  type        = string
}

variable "address_space" {
  description = "VNet CIDR"
  type        = list(string)
}

variable "subnet_prefix" {
  description = "Subnet CIDR"
  type        = list(string)
}

variable "vm_name" {
  description = "VM Name"
  type        = string
}

variable "vm_size" {
  description = "VM Size"
  type        = string
}

variable "admin_username" {
  description = "Admin Username"
  type        = string
}

variable "admin_password" {
  description = "Admin Password"
  type        = string
  sensitive   = true
}

variable "private_ip_address" {
  description = "Static Private IP"
  type        = string
}

variable "my_ip" {
  type = string
}