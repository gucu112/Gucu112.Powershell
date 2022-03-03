param()

try {
    Import-Module Gucu112.Powershell.Utility
} catch {
    Import-Module (Join-Path $PSScriptRoot '..\Gucu112.Powershell.Utility.psd1')
}

Set-Tls -Tls12
