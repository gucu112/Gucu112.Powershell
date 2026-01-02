param(
    [string]$Scope = 'CurrentUser',
    [bool]$Force = $false
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
Install-Module -Name 'Pester' -Scope:$Scope -Force:$Force -SkipPublisherCheck

###
# NuGet
###

# Add-NuGetPackageProvider
Add-PackageProvider -Name 'NuGet' -Force:$Force -ErrorAction Stop | Select-Object -Property $packageProviderProperties

# Add-NuGetPackageSource -Default
Add-PackageSource -Name 'NuGetGallery' -ProviderName 'NuGet' -Location 'https://www.nuget.org/api/v2' -Trusted -Force:$Force -ErrorAction Stop

# Install-Package
Install-Package -Name 'ConfigurationHelper' -ProviderName 'NuGet' -Source 'NuGetGallery' -Destination 'C:\NuGet' -Force:$Force | Out-Null

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

# Get-PackageProvider
Get-PackageProvider -ListAvailable | Format-Table

# Get-PackageSource
Get-PackageSource | Format-Table

# Invoke-Pester
$providers = @(Get-PackageProvider -ListAvailable | Group-Object -Property 'Name' | Where-Object `
    { $PSItem.Name -in @('PowerShellGet', 'NuGet', 'ChocolateyGet') })
$providers | Should -HaveCount 3 -Because "all package providers should be installed"

$sources = @(Get-PackageSource | Group-Object -Property 'Name' | Where-Object `
    { $PSItem.Name -in @('PSGallery', 'NuGetGallery', 'Chocolatey') })
$sources | Should -HaveCount 3 -Because "all package sources should be installed"
foreach ($source in $sources) {
    $source.Group | Where-Object { $_.IsTrusted } | Should -Not -BeNullOrEmpty `
        -Because "package source '$($source.Name)' should be trusted"
}
