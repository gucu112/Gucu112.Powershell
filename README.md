# Gucu112.Powershell

Set of useful powershell utilities for computer and package management provided as separate modules.

## Prerequisites

In order to run Powershell scripts you need to enable it. You can either bypass it entirely:

```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine
```

Or another option is to enable only local network scripts for current user (recommended):

```powershell
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
```

Next you need to setup package management so modules can be loaded correctly if needed:

```powershell
Invoke-Expression -Command "& .\modules\Gucu112.Powershell.PackageManagement\tools\InstallPackageManagement.ps1"
```

It needs to be run with administrator rights as package providers are located in `C:\Program Files\PackageManagement\ProviderAssemblies`.

## Import module locally

Start from root project directory and use this command:

```powershell
Import-Module '.\modules\Gucu112.Powershell.Utility\Gucu112.Powershell.Utility.psd1'
```

If required modules are not loaded then you need to use install script:

```powershell
Invoke-Expression -Command "& .\modules\Gucu112.Powershell.Utility\tools\InstallModule.ps1"
```

You can also load single function which is useful for debugging:

```powershell
Import-Module '.\modules\Gucu112.Powershell.PackageManagement\src\New-ModuleScaffold.psm1'
```

Remember to remove module/function if you want to reload it:

```powershell
Remove-Module 'Gucu112.Powershell.Utility' # module name (psd1)
Remove-Module 'New-ModuleScaffold' # function name (psm1)
```

## Create new module

Run following command from root project directory:

```shell
New-ModuleScaffold -Path '.\modules\Gucu112.Powershell.Test'
```

## Create new functions in the module

Run following command from root project directory:

```shell
New-ModuleFunction -Name @('New-Thing', 'Get-Thing') -Path '.\modules\Gucu112.Powershell.Test'
```

## Tests

Implementation

## Ideas

* Functions
  - Package Management
    - New-ScriptFileInfo
    - Install-Script
  - Utility
    - Get-Path -Absolute
    - ConvertFrom-SecureStringUsingBSTR
    - Write-Message
    - Get-WindowsIdentity -LoggedIn, -Anonymous
* Enhancements
  - Replace `$_` with `$PSItem` for better visibility
  - Change string to ErrorRecord for error collection list
  - Try System.Collections.ArrayList as error collection list
* Documentation & Unit Tests
  - Get-WindowsIdentity
  - Test-WindowsIdentity

## Research

* Check what will happen when we re-use function across module and import module with -Prefix parameter
  - https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/import-module?view=powershell-5.1

## Changelog

### v0.1.0

* Limit Get-PackageProvider output properties
* Improve error handling
* Handle ErrorAction in Add-PackageProvider function
* Install remote modules instead of only importing them
* Change approach to loading modules in scripts
* Update Utility module and manifest
* Improve script parameters
* Implemented only WindowsIdentity functions
* Add install module script
* Add Get-CurrentWindows functions
* Update Utility module manifest
* Update PackageManagement manifest
* Add configuration section
* Update Add-PackageSource function
* Fix PowerShellGet update in Add-PackageProvider function
* Add required modules and update manifest
* Add BetterTls support in Utility package
* Add .NET security protocol update script
* Improve and rename package management main script
* Rename test file template
* Default source for Add-PackageSource
* Install PowerShellGet module in Add-PackageProvider
* Update README & changelog
