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

Not yet implemented.

## Deployment

There are no deployment procedure established yet.

## Contributing

There are no contribution rules established yet.

## Versioning

Modules versioning pattern is defined as follows:

```
v{A}.{b}.{yyMM}.{ddr}
```

**Legend:**

- `{A}` - major version, incrementing only when breaking changes appears, starting from 0
- `{b}` - minor version, incrementing for each release, starting from 0 when new major version introduced
- `{yyMM}` - 2-digits year (range from 00 to 99) with 2-digits month (range from 00 to 12)
- `{ddr}` - 2-digits day of the month (range from 01 to 31) and revison number, incrementing for each daily version, starting from 0

## Authors

- **Bartlomiej Roszczypala** - [Gucu112](https://github.com/gucu112)

See also the list of [contributors](https://github.com/gucu112/CSharpAutomation/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE.txt) file for details.

## Ideas

- Create kanban board
- Functions
  - Package Management
    - New-ScriptFileInfo
    - Install-Script
  - Utility
    - Get-Path -Absolute
    - Resolve-Path -SkipValidate
    - Get-WindowsIdentity -LoggedIn, -Anonymous
    - ConvertFrom-SecureStringAsPlainText
    - Write-Message (?)
- Improvements
  - Replace `$_` with `$PSItem` for better visibility
  - Change string to ErrorRecord for error collection list
  - Try System.Collections.ArrayList as error collection list
- Documentation & Tests
  - Get-WindowsIdentity
  - Test-WindowsIdentity
- Research
  - Check what will happen when we re-use function across module and Import-Module with -Prefix parameter

## Changelog

### v0.1.0

- Limit Get-PackageProvider output properties
- Improve error handling
- Handle ErrorAction in Add-PackageProvider function
- Install remote modules instead of only importing them
- Change approach to loading modules in scripts
- Update Utility module and manifest
- Improve script parameters
- Implemented only WindowsIdentity functions
- Add install module script
- Add Get-CurrentWindows functions
- Update Utility module manifest
- Update PackageManagement manifest
- Add configuration section
- Update Add-PackageSource function
- Fix PowerShellGet update in Add-PackageProvider function
- Add required modules and update manifest
- Add BetterTls support in Utility package
- Add .NET security protocol update script
- Improve and rename package management main script
- Rename test file template
- Default source for Add-PackageSource
- Install PowerShellGet module in Add-PackageProvider
- Update README & changelog
