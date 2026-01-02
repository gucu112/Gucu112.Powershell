param(
    [string]$Scope = 'CurrentUser',
    [bool]$Force = $true
)

##
# Init
###

Write-Verbose "Installing 'Gucu112.Powershell.PackageManagement' required modules."
Install-Module Microsoft.WinGet.Client -RequiredVersion 1.11.460 -Scope:$Scope -Force:$Force

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
# WinGet
###

# Remove-WinGetSource 'winget'
if ($Force.IsPresent -and (Get-WinGetSource -Name 'winget' -ErrorAction Ignore)) {
    Remove-WinGetSource -Name 'winget' -ErrorAction Stop
}

# Add-WinGetSource 'winget'
if (-not (Get-WinGetSource -Name 'winget' -ErrorAction Ignore)) {
    Add-WinGetSource -Name 'winget' -Type 'Microsoft.PreIndexed.Package' `
        -Argument 'https://cdn.winget.microsoft.com/cache' -ErrorAction Stop
}

# Remove-WinGetSource 'msstore'
if ($Force.IsPresent -and (Get-WinGetSource -Name 'msstore' -ErrorAction Ignore)) {
    Remove-WinGetSource -Name 'msstore' -ErrorAction Stop
}

# Add-WinGetSource 'msstore'
if (-not (Get-WinGetSource -Name 'msstore' -ErrorAction Ignore)) {
    Add-WinGetSource -Name 'msstore' -Type 'Microsoft.Rest' `
        -Argument 'https://storeedgefd.dsx.mp.microsoft.com/v9.0' -ErrorAction Stop
}

###
# Test
###

# Get-PackageProvider
Get-PackageProvider -ListAvailable | Format-Table

# Get-PackageSource
Get-PackageSource | Format-Table

# Invoke-Pester
$providerNames = @(Get-PackageProvider -ListAvailable | Select-Object -ExpandProperty 'Name')
$providerNames | Should -Contain 'PowerShellGet'
$providerNames | Should -Contain 'NuGet'
$providerNames | Should -Contain 'ChocolateyGet'

$sourceNames = @(Get-PackageSource | Select-Object -ExpandProperty 'Name')
$sourceNames | Should -Contain 'PSGallery'
$sourceNames | Should -Contain 'NuGetGallery'
$sourceNames | Should -Contain 'Chocolatey'

foreach ($packageSource in Get-PackageSource) {
    $packageSource.Trusted | Should -Be $true -Because `
        "package source '$($packageSource.Name)' should be trusted"
}
