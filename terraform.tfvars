location            = "Central India"
resource_group_name = "ad-migration-rg"

vnet_name     = "ad-vnet"
subnet_name   = "ad-subnet"
address_space = ["10.0.0.0/16"]
subnet_prefix = ["10.0.1.0/24"]

vm_name        = "source-ad-vm"
vm_size        = "Standard_B2s"
admin_username = "azureuser"
admin_password = "StrongPassword@123!"

private_ip_address = "10.0.1.4"

# my_ip = "103.45.**.**"