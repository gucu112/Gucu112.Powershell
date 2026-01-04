param(
    [string]$ComputerName = "Gucu112-LAPTOP"
)

Import-Module (Join-Path $PSScriptRoot '..\..\modules\Gucu112.Powershell.Utility\Gucu112.Powershell.Utility.psd1')

if (-not (Test-WindowsIdentity -Administrator)) {
    Start-Process -FilePath "powershell" -Verb "RunAs" `
        -ArgumentList @("-File", $($MyInvocation.MyCommand.Path))
    exit
}

if ((Get-ComputerInfo).CsDnsHostName -ne $ComputerName) {
    Rename-Computer -NewName $ComputerName
    Write-Information "Computer will be restarted in 5 seconds..."
    Start-Sleep -Seconds 5
    Restart-Computer
}
else {
    Write-Warning "The computer name is already set to '$ComputerName'."
    Start-Sleep -Seconds 5
}
