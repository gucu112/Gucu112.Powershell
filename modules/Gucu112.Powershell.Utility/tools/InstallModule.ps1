param(
    [switch]$Force = $false
)

Write-Verbose "Installing 'Gucu112.Powershell.Utility' required modules."
Install-Module BetterTls -RequiredVersion 0.1.0 -Force:$Force

if (Find-Module Gucu112.Powershell.Utility -RequiredVersion 0.1.0 -ErrorAction Ignore) {
    Write-Verbose "Installing 'Gucu112.Powershell.Utility' module."
    Install-Module Gucu112.Powershell.Utility -RequiredVersion 0.1.0 -Force:$Force
} else {
    Write-Verbose "Importing 'Gucu112.Powershell.Utility' module locally."
    Import-Module (Join-Path $PSScriptRoot '..\Gucu112.Powershell.Utility.psd1') -Force:$Force
}
