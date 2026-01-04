Invoke-Expression -Command "& .\modules\Gucu112.Powershell.PackageManagement\tools\InstallWinGetClient.ps1"

@('Lenovo.SystemUpdate', 'Lenovo.ServiceBridge') | ForEach-Object {
    Install-WinGetPackage -Id $PSItem -MatchOption Equals -Source winget -Mode Silent
}
