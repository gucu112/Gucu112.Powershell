param(
    [switch]$Force = $false,
    [switch]$Confirm
)

try {
    Write-Verbose "Importing 'Gucu112.Powershell.Utility' module."
    Import-Module Gucu112.Powershell.Utility -Force:$Force
} catch {
    Write-Verbose "Importing 'Gucu112.Powershell.Utility' module locally."
    Import-Module (Join-Path $PSScriptRoot '..\Gucu112.Powershell.Utility.psd1') -Force:$Force
}

Set-Tls -Tls12 -Confirm:$Confirm
