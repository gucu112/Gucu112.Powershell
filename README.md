# Gucu112.Powershell

TODO: Add description (here and on github)

## Import module locally

Start from root project directory and use this command:

```shell
Import-Module '.\modules\Gucu112.Powershell.Utility\Gucu112.Powershell.Utility.psd1'
```

You can also load single function:

```shell
Import-Module '.\modules\Gucu112.Powershell.PackageManagement\src\New-ModuleScaffold.psm1'
```

Remember to remove module if you want to reload it:

```shell
Remove-Module 'Gucu112.Powershell.Utility' # module name (psd1)
Remove-Module 'New-ModuleScaffold' # function name (psm1)
```

## Create test module

Run following command from root project directory:

```shell
New-ModuleScaffold -Path '.\modules\Gucu112.Powershell.Test'
```

## Create test functions in the module

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
* What else?
