Import-Module (Join-Path $PSScriptRoot '..\..\modules\Gucu112.Powershell.Utility\Gucu112.Powershell.Utility.psd1')

if (-not (Test-WindowsIdentity -Administrator)) {
    Start-Process -FilePath "powershell" -Verb "RunAs" `
        -ArgumentList @("-File", $($MyInvocation.MyCommand.Path))
    exit
}

$firstLocalUser = Get-LocalUser | Where-Object Enabled | Select-Object -First 1
$firstLocalUser | Rename-LocalUser -NewName 'PC'

# TODO: Try to rename user folder as well

# Restart-Computer
