# Install AD DS Role
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

# Convert password to secure string
$SafeModePassword = ConvertTo-SecureString "Password@123!" -AsPlainText -Force

# Create new forest
Install-ADDSForest `
-DomainName "source.local" `
-SafeModeAdministratorPassword $SafeModePassword `
-InstallDNS `
-Force