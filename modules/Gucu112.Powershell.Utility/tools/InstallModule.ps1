param(
    [switch]$Force = $false
)

Write-Verbose "Installing 'Gucu112.Powershell.Utility' required modules."
Install-Module -Name BetterTls -RequiredVersion 0.1.0 -Force:$Force

try {
    Write-Verbose "Installing 'Gucu112.Powershell.Utility' module."
    Install-Module -Name Gucu112.Powershell.Utility -RequiredVersion 0.1.0 -Force:$Force
} catch {
    Write-Verbose "Importing 'Gucu112.Powershell.Utility' module locally."
    Import-Module (Join-Path $PSScriptRoot '..\Gucu112.Powershell.Utility.psd1') -Force:$Force
}
