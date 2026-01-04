param(
    [string]$Language = "en-US",
    [bool]$CopyToSettings = $true
)

$modulePath = '..\..\modules\Gucu112.Powershell.Utility\tools\InstallModule.ps1'
Invoke-Expression -Command "& $((Resolve-Path (Join-Path $PSScriptRoot $modulePath)).Path)"

if (-not (Test-WindowsIdentity -Administrator)) {
    Start-Process -FilePath "powershell" -Verb "RunAs" `
        -ArgumentList @("-File", $($MyInvocation.MyCommand.Path)) `
        -WorkingDirectory $PSScriptRoot
    exit
}

if (-not (Get-InstalledLanguage -Language $Language) -or $CopyToSettings) {
    Install-Language $Language -CopyToSettings:$CopyToSettings
}

if ((Get-SystemLanguage) -ne $Language) {
    Set-SystemLanguage -Language $Language
    Write-Information "Current user will be logged off in 5 seconds..."
    Start-Sleep -Seconds 5
    Stop-WindowsUser
}
else {
    Write-Warning "The system language is already set to '$Language'."
    Start-Sleep -Seconds 5
}
