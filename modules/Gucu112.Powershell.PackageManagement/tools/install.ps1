##
# Init
###

# Import-Module Gucu112.Powershell.PackageManagement
Import-Module (Join-Path $PSScriptRoot '..\Gucu112.Powershell.PackageManagement.psd1')

# Get-AvailablePackageProvider
Get-PackageProvider -ListAvailable

# Get-PSRepository -Default
Get-PSRepository -Name 'PSGallery'

###
# PSGallery (PowerShellGet)
###

# Add-PSPackageProvider
Add-PackageProvider -Name 'PowerShellGet' -Force

# Add-PSPackageSource
Add-PackageSource -Name 'PSGallery' -ProviderName 'PowerShellGet' -Location 'https://www.powershellgallery.com/api/v2' -Trusted -Force

# Install-Module
Install-Module -Name 'dbatools'

###
# NuGet
###

# Add-NuGetPackageProvider
Add-PackageProvider -Name 'NuGet' -Force

# Add-NuGetPackageSource -Default
Add-PackageSource -Name 'NuGetGallery' -ProviderName 'NuGet' -Location 'https://www.nuget.org/api/v2' -Trusted -Force

# Install-Package
Install-Package -Name 'ConfigurationHelper' -ProviderName 'NuGet' -Destination 'C:\packages'

###
# ChocolateyGet
###

# Add-ChocolateyPackageProvider
Add-PackageProvider -Name 'ChocolateyGet' -Force

# Add-ChocolateyPackageSource -Default
Add-PackageSource -Name 'Chocolatey' -ProviderName 'ChocolateyGet' -Location 'https://www.chocolatey.org/api/v2' -Trusted -Force
