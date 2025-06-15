param(
    [bool]$Force = $true
)

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

# TODO: Investigate how to unload/remove 'PackageManagement' and 'PowerShellGet' modules before update/install 'PowerShellGet' module

# Add-PSPackageProvider
Add-PackageProvider -Name 'PowerShellGet' -Force:$Force -ErrorAction Stop | Select-Object -Property $packageProviderProperties

# Add-PSPackageSource
Add-PackageSource -Name 'PSGallery' -ProviderName 'PowerShellGet' -Location 'https://www.powershellgallery.com/api/v2' -Trusted -Force:$Force -ErrorAction Stop

# Install-Module
Install-Module -Name 'Pester' -Force:$Force -SkipPublisherCheck

###
# NuGet
###

# Add-NuGetPackageProvider
Add-PackageProvider -Name 'NuGet' -Force:$Force -ErrorAction Stop | Select-Object -Property $packageProviderProperties

# Add-NuGetPackageSource -Default
Add-PackageSource -Name 'NuGetGallery' -ProviderName 'NuGet' -Location 'https://www.nuget.org/api/v2' -Trusted -Force:$Force -ErrorAction Stop

# Install-Package
Install-Package -Name 'ConfigurationHelper' -ProviderName 'NuGet' -Destination 'C:\NuGet' -Force:$Force | Out-Null

###
# ChocolateyGet
###

# Add-ChocolateyPackageProvider
Add-PackageProvider -Name 'ChocolateyGet' -Force:$Force -ErrorAction Stop | Select-Object -Property $packageProviderProperties

# Add-ChocolateyPackageSource -Default
Add-PackageSource -Name 'Chocolatey' -ProviderName 'ChocolateyGet' -Location 'https://www.chocolatey.org/api/v2' -Trusted -Force:$Force -ErrorAction Stop

###
# Test
###

# Get-PackageSource
Get-PackageSource | Format-Table

# Invoke-Pester
(Get-PackageSource).Count | Should -Be 3

# TODO: Check also if all package sources are trusted
