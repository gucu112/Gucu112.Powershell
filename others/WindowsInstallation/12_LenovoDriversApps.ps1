# TODO: Include this module as required in PackageManagement module
# Install-Module -Name 'Microsoft.WinGet.Client'
Import-Module -Name 'Microsoft.WinGet.Client'

# TODO: Move to InstallPackageManagement script
Add-WinGetSource -Name winget -Argument https://cdn.winget.microsoft.com/cache -Type Microsoft.PreIndexed.Package
Add-WinGetSource -Name msstore -Argument https://storeedgefd.dsx.mp.microsoft.com/v9.0 -Type Microsoft.Rest

# TODO: Move to documentation
# Inno Setup Parameters
# https://jrsoftware.org/ishelp/index.php?topic=setupcmdline
# NSIS Setup Parameters
# https://nsis.sourceforge.io/Docs/Chapter3.html

@('Lenovo.SystemUpdate', 'Lenovo.ServiceBridge') | ForEach-Object {
    Install-WinGetPackage -Id $PSItem -MatchOption Equals -Source winget -Mode Silent
}
