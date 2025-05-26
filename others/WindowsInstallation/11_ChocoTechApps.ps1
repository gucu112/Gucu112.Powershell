# TODO: Check if it works without setting up the Chocolatey package provider
# Invoke-Expression -Command "& .\modules\Gucu112.Powershell.PackageManagement\tools\InstallPackageManagement.ps1"

# CPlusPlus & CSharp
@('vcredist-all', 'directx', 'dotnetfx', 'dotnet-sdk') | ForEach-Object {
    Find-Package $PSItem -Source Chocolatey | Install-Package -AcceptLicense
}

# Powershell
Install-Package 'powershell-core' -Source Chocolatey -AcceptLicense

# Python
Install-Package 'python' -Source Chocolatey -AdditionalArguments '--paramsglobal' -PackageParameters "/InstallDir:C:\Python" -AcceptLicense

# JavaScript
Install-Package 'nodejs-lts' -Source Chocolatey -AcceptLicense

# Java
Install-Package 'openjdk' -Source Chocolatey -AcceptLicense

# Audio & Video
Install-Package 'k-litecodecpackfull' -Source Chocolatey -AcceptLicense
Install-Package 'asio4all' -Source Chocolatey -InstallArguments "/D=C:\Program Files (x86)\ASIO4ALL" -AcceptLicense
Get-ChildItem -Path "$env:USERPROFILE\Desktop" -Filter 'asio4all*.lnk' | Remove-Item

# Update Chocolatey packages
$updatePackagesProperties = @('Name', @{Label = 'CurrentVersion'; Expression = { $_.Version } }, @{Label = 'LatestVersion'; Expression = { (Find-Package $_.Name -Provider ChocolateyGet).Version } })
$updatePackages = Get-Package -ProviderName ChocolateyGet | Select-Object -Property $updatePackagesProperties | Where-Object { $_.CurrentVersion -lt $_.LatestVersion }
$updatePackages | ForEach-Object { Install-Package -Name $_.Name -Source Chocolatey -AcceptLicense -ErrorAction SilentlyContinue | Out-Default }
