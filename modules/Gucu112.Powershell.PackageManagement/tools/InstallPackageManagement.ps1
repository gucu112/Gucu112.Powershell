##
# Init
###

if (Find-Module Gucu112.Powershell.PackageManagement -ErrorAction Ignore) {
    Install-Module Gucu112.Powershell.PackageManagement
} else {
    Import-Module (Join-Path $PSScriptRoot '..\Gucu112.Powershell.PackageManagement.psd1')
}

$packageProviderProperties = (Get-Module Gucu112.Powershell.PackageManagement).PrivateData.Configuration.PackageProviderProperties

# Get-AvailablePackageProvider
Get-PackageProvider -ListAvailable

# Get-PSRepository -Default
Get-PSRepository -Name 'PSGallery'

###
# PowerShellGet
###

# Add-PSPackageProvider
Add-PackageProvider -Name 'PowerShellGet' -Force -ErrorAction Stop | Select-Object -Property $packageProviderProperties

# Add-PSPackageSource
Add-PackageSource -Name 'PSGallery' -ProviderName 'PowerShellGet' -Location 'https://www.powershellgallery.com/api/v2' -Trusted -Force

# Install-Module
Install-Module -Name 'dbatools'

###
# NuGet
###

# Add-NuGetPackageProvider
Add-PackageProvider -Name 'NuGet' -Force -ErrorAction Stop | Select-Object -Property $packageProviderProperties

# Add-NuGetPackageSource -Default
Add-PackageSource -Name 'NuGetGallery' -ProviderName 'NuGet' -Location 'https://www.nuget.org/api/v2' -Trusted -Force

# Install-Package
Install-Package -Name 'ConfigurationHelper' -ProviderName 'NuGet' -Destination 'C:\NuGet'

###
# ChocolateyGet
###

# Add-ChocolateyPackageProvider
Add-PackageProvider -Name 'ChocolateyGet' -Force -ErrorAction Stop | Select-Object -Property $packageProviderProperties

# Add-ChocolateyPackageSource -Default
Add-PackageSource -Name 'Chocolatey' -ProviderName 'ChocolateyGet' -Location 'https://www.chocolatey.org/api/v2' -Trusted -Force
