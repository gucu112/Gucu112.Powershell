param(
    [string]$ComputerName = "Gucu112-LAPTOP"
)

$modulePath = '..\..\modules\Gucu112.Powershell.Utility\tools\InstallModule.ps1'
Invoke-Expression -Command "& $((Resolve-Path (Join-Path $PSScriptRoot $modulePath)).Path)"

if (-not (Test-WindowsIdentity -Administrator)) {
    Start-Process -FilePath "powershell" -Verb "RunAs" `
        -ArgumentList @("-File", $($MyInvocation.MyCommand.Path)) `
        -WorkingDirectory $PSScriptRoot
    exit
}

if ((Get-LocalDomain) -ne $ComputerName) {
    Rename-Computer -NewName $ComputerName
    Write-Information "Computer will be restarted in 5 seconds..."
    Start-Sleep -Seconds 5
    Restart-Computer
}
else {
    Write-Warning "The computer name is already set to '$ComputerName'."
    Start-Sleep -Seconds 5
}
