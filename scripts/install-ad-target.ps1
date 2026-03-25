# Install AD DS Role
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

Import-Module ADDSDeployment

# Safe mode password
$securePassword = ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force

# Create NEW forest (target.local)
Install-ADDSForest `
    -DomainName "target.local" `
    -SafeModeAdministratorPassword $securePassword `
    -InstallDNS `
    -Force