Invoke-Expression -Command "& .\modules\Gucu112.Powershell.PackageManagement\tools\InstallPackageManagement.ps1 -Force:`$false"

@('Lenovo.SystemUpdate', 'Lenovo.ServiceBridge') | ForEach-Object {
    Install-WinGetPackage -Id $PSItem -MatchOption Equals -Source winget -Mode Silent
}
