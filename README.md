# Gucu112.Powershell

Set of useful powershell utilities for computer and package management provided as separate modules.

## Getting started

### Prerequisites

In order to run Powershell scripts you need to enable it. You can either bypass it entirely:

```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine
```

Or another option is to enable only local network scripts for current user (recommended):

```powershell
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
```

Next you need to setup package management so resources can be loaded correctly if needed:

```powershell
Invoke-Expression -Command "& .\modules\Gucu112.Powershell.Utility\tools\SetTls.ps1"
Invoke-Expression -Command "& .\modules\Gucu112.Powershell.PackageManagement\tools\InstallPackageManagement.ps1"
```

It needs to be run with administrator rights as package providers are located in `C:\Program Files\PackageManagement\ProviderAssemblies`.

### Running

#### Import module locally

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
Import-Module '.\modules\Gucu112.Powershell.Utility\src\Test-WindowsIdentity.psm1'
```

Remember to remove module/function if you want to reload it:

```powershell
Remove-Module 'Gucu112.Powershell.Utility' # module name (psd1)
Remove-Module 'Test-WindowsIdentity' # function name (psm1)
```

### Developing

Start from root project directory and use this command:

```powershell
Import-Module '.\modules\Gucu112.Powershell.PackageManagement\Gucu112.Powershell.PackageManagement.psd1'
```

## Create new module

Run following command from root project directory:

```shell
New-ModuleScaffold -Path '.\modules\Gucu112.Powershell.MyModule'
```

## Create new functions in the module

Run following command from root project directory:

```shell
New-ModuleFunction -Name @('New-Thing', 'Get-Thing', 'Test-Thing') -Path '.\modules\Gucu112.Powershell.MyModule'
```

### Testing

You can run single module tests using respective `RunTestsLocally.ps1` script:

```shell
Install-Module Pester
Invoke-Expression -Command "& .\modules\Gucu112.Powershell.Utility\tools\RunTestsLocally.ps1"
```

Remember to update script path in the command above to target selected module.

Optionally, you can also run static analysis of the module using this command:

```shell
Install-Module PSScriptAnalyzer
Invoke-ScriptAnalyzer -Path ".\modules\Gucu112.Powershell.Utility" -Recurse
```

## Deployment

Only after successful run and test it is reasonable to publish module:

```shell
Publish-Module -Path ".\modules\Gucu112.Powershell.Utility" -NuGetApiKey "$env:NUGET_API_KEY"
```

## Contributing

There are couple of contribution rules established:

- Left blank line after `using` and before `function`
- Use `$PSItem` instead of `$_` in nested code blocks
- Add `Write-Verbose` messages where necessary
- Support `ShouldProcess` if applicable

## Versioning

Modules versioning pattern is defined as follows:

```text
v{A}.{b}.{yyMM}.{ddr}
```

**Legend:**

- `{A}` - major version, incrementing only when breaking changes appears, starting from 0
- `{b}` - minor version, incrementing for each release, starting from 0 when new major version introduced
- `{yyMM}` - 2-digits year (range from 00 to 99) with 2-digits month (range from 00 to 12)
- `{ddr}` - 2-digits day of the month (range from 01 to 31) and patch number, incrementing for each daily version, starting from 0

## Authors

- **Bartlomiej Roszczypala** - [Gucu112](https://github.com/gucu112)

See also the list of [contributors](https://github.com/gucu112/Gucu112.Powershell/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE.txt) file for details.

## Ideas

- Create kanban board
- Documentation & Unit + E2E Tests
  - New-ModuleScaffold
  - New-ModuleFunction
  - Get-WindowsIdentity
  - Test-WindowsIdentity
- Enhancements
  - Consider System.Collections.ArrayList as error collection list
  - Update module manifest when calling `New-ModuleScaffold` or `New-ModuleFunction` function (current code commented out)
  - Add and update `PrivateData.PSData.ExternalModuleDependencies` module manifest property automatically
  - Check different root module types (see `-RootModule` parameter of New-ModuleManifest)
  - Check what will happen when we re-use function across module and Import-Module with -Prefix parameter
- Functions
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
    - Resolve-Path -SkipValidate
    - ConvertFrom-SecureStringAsPlainText
    - Write-Message (?)
    - Get-FileEncoding
    - Set-FileEncoding
    - Compare-SecureString
    - Compare-PSCredential
    - Register-ScheduledTask
    - Unregister-ScheduledTask
    - New-ScheduledTaskXML
    - Merge-ScheduledTaskXML
    - RemoveTempFiles
- Research
  - Investigate how to [install PowerShellGet](https://docs.microsoft.com/en-us/powershell/scripting/gallery/installing-psget?view=powershell-5.1) module
  - Investigate following modules and functions
    - [Core](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/?view=powershell-5.1)
      - Get-Module
    - [PowerShellGet](https://docs.microsoft.com/en-us/powershell/module/powershellget/?view=powershell-5.1)
      - Find-Module
      - Find-Script
      - Get-InstalledModule
      - Get-InstalledScript
      - Install-Script
      - New-ScriptFileInfo
      - Uninstall-Module
      - Uninstall-Script
    - [PackageManagement](https://docs.microsoft.com/en-us/powershell/module/packagemanagement/?view=powershell-5.1)
      - Find-Package
      - Get-Package
      - Uninstall-Package

## Useful links

- [Inno Setup Parameters](https://jrsoftware.org/ishelp/index.php?topic=setupcmdline)
- [NSIS Setup Parameters](https://nsis.sourceforge.io/Docs/Chapter3.html)
