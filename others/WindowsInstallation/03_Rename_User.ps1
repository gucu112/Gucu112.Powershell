$modulePath = '..\..\modules\Gucu112.Powershell.Utility\tools\InstallModule.ps1'
Invoke-Expression -Command "& $((Resolve-Path (Join-Path $PSScriptRoot $modulePath)).Path)"

if (-not (Test-WindowsIdentity -Administrator)) {
    Start-Process -FilePath "powershell" -Verb "RunAs" `
        -ArgumentList @("-File", $($MyInvocation.MyCommand.Path)) `
        -WorkingDirectory $PSScriptRoot
    exit
}

$firstLocalUser = Get-LocalUser | Where-Object Enabled | Select-Object -First 1
$firstLocalUser | Rename-LocalUser -NewName 'PC'

# TODO: Try to rename user folder as well

# Restart-Computer
