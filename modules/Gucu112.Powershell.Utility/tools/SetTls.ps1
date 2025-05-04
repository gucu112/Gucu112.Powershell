param(
    [switch]$Force = [switch]::NotPresent,
    [switch]$Confirm = [switch]::Present
)

if ($Force.IsPresent) {
    $Confirm = [switch]::NotPresent
}

if (Find-Module Gucu112.Powershell.Utility -ErrorAction Ignore) {
    Write-Verbose "Installing 'Gucu112.Powershell.Utility' module."
    Install-Module Gucu112.Powershell.Utility -Force:$Force
} else {
    Write-Verbose "Importing 'Gucu112.Powershell.Utility' module locally."
    Import-Module (Join-Path $PSScriptRoot '..\Gucu112.Powershell.Utility.psd1') -Force:$Force
}

Set-Tls -Tls12 -Confirm:$Confirm

Get-Tls
