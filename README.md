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
New-ModuleFunction -Name @('Get-Thing', 'New-Thing') -Path '.\modules\Gucu112.Powershell.Test'
```

## Tests

Implementation

## Ideas

* Functions & Scripts
  - Package Management
    - New-ScriptFile (use New-ScriptFileInfo)
    - Install-ModuleLocally
    - Get-PSModulePath
    - Set-PSModulePath
    - Add-PSModulePath
    - Get-StandardPSModulePath
  - Utility
    - Get-DnsDomain, Get-DnsHostEntry
    - Get-Path -Absolute
    - ConvertFrom-SecureStringUsingBSTR
    - Write-Message
    - Get-FileEncoding
    - Set-FileEncoding
    - Compare-SecureString
    - Compare-PSCredential
    - Register-ScheduledTask
    - Unregister-ScheduledTask
    - New-ScheduledTaskXML
    - Merge-ScheduledTaskXML
    - RemoveTempFiles
* Enhancements
  - Add `using` section to function file template
  - Add `Write-Verbose` messages where applicable
  - Always use `[switch]::Present` and `[switch]::NotPresent` as default values for switches
  - Change `string` to `ErrorRecord` for error collection list
  - Move C# files to Visual Studio solution
  - Check which encoding should I apply when calling `Get-Content` and `Set-Content` (set default encoding)
* Documentation & Unit Tests
  - New-ModuleScaffold
  - New-ModuleFunction
  - Get-WindowsIdentity
  - Test-WindowsIdentity

## Research

* Investigate how to install PowerShellGet module
  - https://docs.microsoft.com/en-us/powershell/scripting/gallery/installing-psget?view=powershell-5.1
* Investigate following modules and functions
  - Core (https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/?view=powershell-5.1)
    - Get-Module
  - PowerShellGet (https://docs.microsoft.com/en-us/powershell/module/powershellget/?view=powershell-5.1)
    - Find-Module
    - Find-Script
    - Get-InstalledModule
    - Get-InstalledScript
    - Install-Script
    - New-ScriptFileInfo
    - Uninstall-Module
    - Uninstall-Script
  - PackageManagement (https://docs.microsoft.com/en-us/powershell/module/packagemanagement/?view=powershell-5.1)
    - Find-Package
    - Get-Package
    - Uninstall-Package
* Investigate how multiple errors are thrown (when `CompileCSharp.ps1` script fails)
* Update module manifest when calling `New-ModuleScaffold` or `New-ModuleFunction` function (current code commented out)
* Add and update `PrivateData.PSData.ExternalModuleDependencies` module manifest property automatically
* Check different root module types (see `-RootModule` parameter)
  - https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/new-modulemanifest?view=powershell-5.1
* Check what will happen when we re-use function across module and import module with `-Prefix` parameter
  - https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/import-module?view=powershell-5.1
* What else?
